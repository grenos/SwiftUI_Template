//
//  EmailAuth.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 22/11/20.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

extension SessionObject {
	
	
	func signUp(email: String,
				password: String,
				completion: @escaping (Result<Void.Type, FBAuthError>) -> Void)
	{
		firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
			if let error = error {
				print("Error signing in: \(error.localizedDescription)")
				completion(.failure(.genericAuthError))
			}
			else {
				completion(.success(Void.self))
			}
		}
	}
	
	
	func signIn(email: String,
				password: String,
				completion: @escaping (Result<Void.Type, FBAuthError>) -> Void)
	{
		firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
			guard let user = authResult?.user, error == nil else {
				print("Error signing in: \(error!.localizedDescription)")
				completion(.failure(.genericAuthError))
				return
			}
			self.user = user
			Persistence.isEmailUser = true
			completion(.success(Void.self))
		}
	}
	
	
	
	func signOut(completion: @escaping (Error?) -> Void) {
		
		if Persistence.isGoogleUser {
			GIDSignIn.sharedInstance()?.signOut()
			Persistence.isGoogleUser = false
		}
		
		if Persistence.isAppleUser {
			Persistence.isAppleUser = false
		}
		
		if Persistence.isFacebookUser {
			Persistence.isFacebookUser = false
		}
		
		do {
			Persistence.isEmailUser = false
			self.user = nil
			self.unbind()
			try firebaseAuth.signOut()
		} catch let error {
			completion(error)
		}
	}
}
