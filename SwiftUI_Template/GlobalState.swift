//
//  GlobalState.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

enum Coordinator: Hashable {
	case scrrenOne
	case scrrenTwo
	case none
}

enum StateSlice: Hashable {
	case test
	case activeTab
	case hideTab
}


final class GlobalState: ObservableObject {
	
	// default state
	@Published var test: String
	
	
	// tab navigation
	@Published var selectedTabItem: TabItem
	@Published var hideTabbar: Bool
	// coordinator
	@Published var pushedProgrmatically: Bool
	@Published var pushedScreen: Coordinator?
	
	
	init() {
		self.test = Persistence.test.count != 0 ? Persistence.test : "default value"
		
		// navigation and tabs
		self.selectedTabItem = TabItem.home
		self.hideTabbar = false
		self.pushedProgrmatically = false
		self.pushedScreen = Coordinator.none
	}
	

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
			case .hideTab:
				self.hideTabbar = value as! Bool
		}
	}
}

