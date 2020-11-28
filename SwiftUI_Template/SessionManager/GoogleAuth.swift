//
//  GoogleAuth.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 28/11/20.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

extension SessionObject {
	
	func loginWithGoogle(onGoogleSigninCompletion: @escaping (Result<Void.Type, FBAuthError>) -> Void) {
		GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
		GIDSignIn.sharedInstance()?.signIn()
		self.onGoogleSigninCompletion = onGoogleSigninCompletion
	}
	
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if error != nil{
			print("Error getting google credentials: \(error.localizedDescription)")
			if let callback = self.onGoogleSigninCompletion {
				callback(.failure(.genericAuthError))
			}
			return
		}
		
		let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken,
													   accessToken: user.authentication.accessToken)
		
		firebaseAuth.signIn(with: credential) { [weak self] (authResult, error) in
			guard let self = self else { return }
			guard let user = authResult?.user, error == nil else {
				print("Error signing in with google: \(error!.localizedDescription)")
				if let callback = self.onGoogleSigninCompletion {
					callback(.failure(.genericAuthError))
				}
				return
			}
			
			self.user = user
			self.isNewUser = ((authResult?.additionalUserInfo?.isNewUser) != nil)
			Persistence.isGoogleUser = true
			if let callback = self.onGoogleSigninCompletion {
				callback(.success(Void.self))
			}
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		// Perform Action When user Logs Out...
	}
	
	
	
}
