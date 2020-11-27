//
//  EmailAuth.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 22/11/20.
//

import Foundation
import FirebaseAuth

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
		firebaseAuth.signIn(withEmail: email, password: password) { _, error in
			if let error = error {
				print("Error signing in: \(error.localizedDescription)")
				completion(.failure(.genericAuthError))
			}
			else {
				completion(.success(Void.self))
			}
		}
	}
	
	
	func signOut(completion: @escaping (Error?) -> Void) {
		do {
			try firebaseAuth.signOut()
			self.user = nil
		} catch let error {
			completion(error)
		}
	}
}
