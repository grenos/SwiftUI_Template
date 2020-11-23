//
//  SessionObject.swift
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


final class SessionObject: ObservableObject {
		
	@Published var test: String
	// tab navigation
	@Published var selectedTabItem: TabItem
	// coordinator
	@Published var pushedProgrmatically: Bool
	@Published var pushedScreen: Coordinator?
	// auth session
	@Published var user: User?
	@Published var authListener: AuthStateDidChangeListenerHandle?
	
	init() {
		self.test = " default value"
		// navigation and tabs
		self.selectedTabItem = TabItem.home
		self.pushedProgrmatically = false
		self.pushedScreen = Coordinator.none
		self.user = nil
		self.authListener = nil
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

