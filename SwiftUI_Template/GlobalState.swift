//
//  GlobalState.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI


enum StateSlice: Hashable {
	case test
	case activeTab
}


class GlobalState: ObservableObject {
	
	@Published var test: String
	
	// tab navigation
	@Published var selectedTabItem = TabItem.home
	
	
	init() {
		self.test = "default value"
	}
	

	func setValue<T: Any>(slice: StateSlice, value: T, persist: Bool? = false) {
		switch slice {
			case StateSlice.test:
				self.test = value as! String
				if persist! {
					UserDefaultsConfig.test = value as! String
				}
				
			// Tab item navigation
			case StateSlice.activeTab:
				self.selectedTabItem = value as! TabItem
		}
	}
}

