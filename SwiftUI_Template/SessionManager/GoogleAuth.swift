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
	
	func loginWithGoogle() {
		GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
		GIDSignIn.sharedInstance()?.signIn()
	}
	

	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if error != nil{
			print("Error getting google credentials: \(error.localizedDescription)")
//			completion(.failure(.genericAuthError))
			return
		}
		
		let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
		firebaseAuth.signIn(with: credential) { (authResult, error) in
			guard let user = authResult?.user, error == nil else {
				print("Error signing in with google: \(error!.localizedDescription)")
//				completion(.failure(.genericAuthError))
				return
			}
			
			self.user = user
			self.isNewUser = ((authResult?.additionalUserInfo?.isNewUser) != nil)
			Persistence.isGoogleUser = true
//			completion(.success(Void.self))
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		// Perform Action When user Logs Out...
	}
	
	
	
}
