//
//  FacebookAuth.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 28/11/20.
//

import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

extension SessionObject {
	
	func LoginWithFacebook(completion: @escaping (Result<Void.Type, FBAuthError>) -> Void) {
		let fbLoginManager: LoginManager = LoginManager()
		
		fbLoginManager.logIn(permissions: ["email", "public_profile"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
			
			if let error = error {
				print("Error getting facebook credentials: \(error.localizedDescription)")
				completion(.failure(.genericAuthError))
				return
			}
			
			let accessToken = AccessToken.current!.tokenString
			let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
			
			firebaseAuth.signIn(with: credential) { [weak self] (authResult, error) in
				guard let self = self else { return }
				guard let user = authResult?.user, error == nil else {
					print("Error signing in with facebook: \(error!.localizedDescription)")
					completion(.failure(.genericAuthError))
					return
				}
				
				self.user = user
				self.isNewUser = ((authResult?.additionalUserInfo?.isNewUser) != nil)
				Persistence.isFacebookUser = true
				completion(.success(Void.self))
			}
		}
	}
}





