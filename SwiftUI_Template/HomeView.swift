//
//  HomeView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI
import Introspect

struct HomeView: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	@AppStorage("isUserLogged") var isUserLogged: Bool?
		
	init(){}
	
	func willAppear() {
		// push programatically (can be on any view)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//			sessionObject.setValue(slice: StateSlice.pushedProgrmatically, value: true)
//		}
		
		// pop programatically (can be on any view)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
//			sessionObject.setValue(slice: StateSlice.pushedProgrmatically, value: false)
//		}
	}
	
	func willDisappear() {
	}
	
	var body: some View {
		NavigationView {
			VStack {
				Text(sessionObject.test)
					.padding()
					.onTapGesture(perform: {
						sessionObject.setValue(slice: StateSlice.test, value: "Updated Value, Saved on state and persisted", persist: true)
					})
				
				Text("Navigate to tab")
					.onTapGesture(perform: {
						sessionObject.setValue(slice: StateSlice.activeTab, value: TabItem.other)
					})
				
				Text("SIGN OUT")
					.padding(.bottom, 20)
					.onTapGesture {
						sessionObject.signOut { error in
							if let error = error {
								print("Error signin you out: \(error)")
							}
						}
					}
				
				
				// push programatically either from VM or from this view (uncomment on lifecycles)
				NavigationLink("I can also be pushed programatically from my VM", destination: Text("Pushed programatically"), isActive: $sessionObject.pushedProgrmatically)
				
				// for multiple navigation links
				NavigationLink(destination: fakeView1(), tag: Coordinator.scrrenOne, selection: $sessionObject.pushedScreen) { Rectangle().fill(Color.red).frame(width: 100, height: 100) }
				
				NavigationLink(destination: Text("SCREEN TWO").navigationBarTitle("Detail", displayMode: .large), tag: Coordinator.scrrenTwo, selection: $sessionObject.pushedScreen) { Rectangle().fill(Color.green).frame(width: 100, height: 100) }
					.isDetailLink(false)
				
			}
			.navigationTitle("Home")
			.onAppear { willAppear() }
			.onDisappear { willDisappear() }
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView().environmentObject(SessionObject())
		
	}
}
