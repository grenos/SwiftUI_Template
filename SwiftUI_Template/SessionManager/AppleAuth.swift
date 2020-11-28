//
//  AppleAuth.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 28/11/20.
//


import Foundation
import CryptoKit
import AuthenticationServices
import Firebase


extension SessionObject {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return UIApplication.shared.windows.first!
	}
	
	func startSignInWithAppleFlow(onAppleSigninCompletion: @escaping (Result<Void.Type, FBAuthError>) -> Void) {
		self.onAppleSigninCompletion = onAppleSigninCompletion
		let nonce = randomNonceString()
		self.currentNonce = nonce
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]
		request.nonce = sha256(nonce)
		
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
	
	private func sha256(_ input: String) -> String {
		let inputData = Data(input.utf8)
		let hashedData = SHA256.hash(data: inputData)
		let hashString = hashedData.compactMap {
			return String(format: "%02x", $0)
		}.joined()
		
		return hashString
	}
	
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			guard let nonce = currentNonce else {
				fatalError("Invalid state: A login callback was received, but no login request was sent.")
				if let callback = self.onAppleSigninCompletion {
					callback(.failure(.genericAuthError))
				}
			}
			guard let appleIDToken = appleIDCredential.identityToken else {
				print("Unable to fetch identity token")
				if let callback = self.onAppleSigninCompletion {
					callback(.failure(.genericAuthError))
				}
				return
			}
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
				if let callback = self.onAppleSigninCompletion {
					callback(.failure(.genericAuthError))
				}
				return
			}
			
			var displayName: String = ""
			if let givenName = appleIDCredential.fullName?.givenName, let familyName = appleIDCredential.fullName?.familyName {
				displayName = "\(givenName) \(familyName)"
			}
			
			let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
			
			firebaseAuth.signIn(with: credential) { [weak self] authResult, error in
				guard let self = self else { return }
				if error != nil { print(error?.localizedDescription ?? "Error signing in Apple user to Firebase")}
				
				if let user = firebaseAuth.currentUser {
					let changeRequest = user.createProfileChangeRequest()
					changeRequest.displayName = displayName
					changeRequest.commitChanges { error in
						if error != nil {
							print("Error updating display name")
							if let callback = self.onAppleSigninCompletion {
								callback(.failure(.genericAuthError))
							}
						}
						if let user = authResult?.user {
							self.user = user
							self.isNewUser = ((authResult?.additionalUserInfo?.isNewUser) != nil)
							Persistence.isAppleUser = true
							if let callback = self.onAppleSigninCompletion {
								callback(.success(Void.self))
							}
						}
					}
				}
			}
		}
	}
}




// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
	precondition(length > 0)
	let charset: Array<Character> =
		Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
	var result = ""
	var remainingLength = length
	
	while remainingLength > 0 {
		let randoms: [UInt8] = (0 ..< 16).map { _ in
			var random: UInt8 = 0
			let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
			if errorCode != errSecSuccess {
				fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
			}
			return random
		}
		
		randoms.forEach { random in
			if remainingLength == 0 {
				return
			}
			
			if random < charset.count {
				result.append(charset[Int(random)])
				remainingLength -= 1
			}
		}
	}
	
	return result
}
