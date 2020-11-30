//
//  SessionListener.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 30/11/20.
//

import Foundation


extension SessionObject {
	func listen () {
		authListener = firebaseAuth.addStateDidChangeListener { (auth, user) in
			if let user = user {
				self.user = user
			} else {
				self.user = nil
			}
		}
	}
	
	func unbind () {
		if let authListener = authListener {
			firebaseAuth.removeStateDidChangeListener(authListener)
		}
	}
}
