//
//  GlobalState.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI
import FirebaseAuth

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


final class GlobalState: ObservableObject {
		
	// default state
	@Published var test: String
	
	// tab navigation
	@Published var selectedTabItem: TabItem
	// coordinator
	@Published var pushedProgrmatically: Bool
	@Published var pushedScreen: Coordinator?
	
	
	init() {
		self.test = Persistence.test.count != 0 ? Persistence.test : "default value"
		
		// navigation and tabs
		self.selectedTabItem = TabItem.home
		self.pushedProgrmatically = false
		self.pushedScreen = Coordinator.none
		
	}
	

	// Reducer
	func setValue<T: Any>(slice: StateSlice, value: T, persist: Bool? = false) {
		switch slice {
			
			case .test:
				self.test = value as! String
				if persist! {
					Persistence.test = value as! String
				}
				
			// Tab item navigation
			case .activeTab:
				self.selectedTabItem = value as! TabItem
				
			case .pushedProgrmatically:
				self.pushedProgrmatically = value as! Bool
		}
	}
	
	
	
	
	
	

		@Published var session: User?
		@Published var handle: AuthStateDidChangeListenerHandle?
		
		
		func listen () {
			// monitor authentication changes using firebase
			handle = Auth.auth().addStateDidChangeListener { (auth, user) in
				if let user = user {
					// if we have a user, create a new user model
					print("Got user: \(user)")
					self.session = user
				} else {
					// if we don't have a user, set our session to nil
					self.session = nil
				}
			}
		}
		
		
		func unbind () {
			if let handle = handle {
				Auth.auth().removeStateDidChangeListener(handle)
			}
		}
		
		
		func signUp(email: String,
					password: String,
					handler: @escaping AuthDataResultCallback)
		{
			Auth.auth().createUser(withEmail: email, password: password, completion: handler)
		}
		
		func signIn(email: String,
					password: String,
					handler: @escaping AuthDataResultCallback)
		{
			Auth.auth().signIn(withEmail: email, password: password, completion: handler)
		}
		
		func signOut () -> Bool {
			do {
				try Auth.auth().signOut()
				self.session = nil
				return true
			} catch {
				return false
			}
		}
	
	
}

