//
//  SessionObject.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn


enum Coordinator: Hashable {
	case scrrenOne
	case scrrenTwo
	case none
}

enum StateSlice: Hashable {
	case test
	case activeTab
	case pushedProgrmatically
}


class SessionObject: NSObject, ObservableObject, GIDSignInDelegate {
	
	@Published var test: String = "default value"
	// tab navigation
	@Published var selectedTabItem: TabItem = TabItem.home
	// coordinator
	@Published var pushedProgrmatically: Bool = false
	@Published var pushedScreen: Coordinator? = Coordinator.none
	// auth session
	@Published var user: User? = nil
	@Published var authListener: AuthStateDidChangeListenerHandle? = nil
	@Published var isNewUser: Bool = true
	
	
	override init() {
		super.init()
		GIDSignIn.sharedInstance().delegate = self
	}
	
	
	func setValue<T: Any>(slice: StateSlice, value: T, persist: Bool? = false) {
		switch slice {
			
			case .test:
				self.test = value as! String
				if persist! {
					Persistence.test = value as! String
				}
				
			case .activeTab:
				self.selectedTabItem = value as! TabItem
				
			case .pushedProgrmatically:
				self.pushedProgrmatically = value as! Bool
		}
	}
	
	
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

