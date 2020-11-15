//
//  HomeView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI
import Introspect

struct HomeView: View {
	
	@EnvironmentObject var globalState: GlobalState
		
	init(){}
	
	func willAppear() {
		globalState.setValue(slice: StateSlice.hideTab, value: false)
		// push programatically (can be on any view)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//			self.globalState.pushedProgrmatically = true
//		}
		
		// pop programatically (can be on any view)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
//			self.globalState.pushedProgrmatically = false
//		}
	}
	
	func willDisappear() {
		globalState.setValue(slice: StateSlice.hideTab, value: true)
	}
	
	var body: some View {
		NavigationView {
			VStack {
				Text(globalState.test)
					.padding()
					.onTapGesture(perform: {
						globalState.setValue(slice: StateSlice.test, value: "Updated Value, Saved on state and persisted", persist: true)
					})
				
				Text("Navigate to tab")
					.onTapGesture(perform: {
						globalState.setValue(slice: StateSlice.activeTab, value: TabItem.other)
					})
				
				
				
				
				// push programatically either from VM or from this view (uncomment on lifecycles)
				NavigationLink("I can also be pushed programatically from my VM", destination: Text("Pushed programatically"), isActive: $globalState.pushedProgrmatically)
				
				// for multiple navigation links
				NavigationLink(destination: fakeView1(), tag: Coordinator.scrrenOne, selection: $globalState.pushedScreen) { Rectangle().fill(Color.red).frame(width: 100, height: 100) }
				
				NavigationLink(destination: Text("SCREEN TWO").navigationBarTitle("Detail", displayMode: .large), tag: Coordinator.scrrenTwo, selection: $globalState.pushedScreen) { Rectangle().fill(Color.green).frame(width: 100, height: 100) }
				
			}
			.navigationTitle("Home")
			.onAppear { willAppear() }
			.onDisappear { willDisappear() }
		}

		
		.introspectTabBarController() { (UITabBarController) in
			UITabBarController.tabBar.isHidden = globalState.hideTabbar
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView().environmentObject(GlobalState())
		
	}
}
