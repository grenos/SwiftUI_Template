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
	@State private var testValue = false
	
	func willAppear() {
		// push programatically (can be on any view)
//				DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//				sessionObject.pushedScreen = Navigator.scrrenOne
//				}
		
		// pop programatically (can be on any view)
		//		DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
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
						sessionObject.test = "Updated Value and saved on state"
					})
				
				Text("Navigate to tab")
					.onTapGesture(perform: {
						sessionObject.selectedTabItem = TabItem.other
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
				
				
				if testValue {
					Text("BLAH")
				}
				
				
				Button("Tap go to fakeVIew1") {
					sessionObject.pushedScreen = Navigator.scrrenOne
				}
				Button("Tap to go to fakeView2") {
					sessionObject.pushedScreen = Navigator.scrrenTwo
				}
				// programatical navigaton
				// set an active screen on sessionObject
				// when you want to return to the previous page (also programatically)
				// set the same sessionObject property to none
				NavigationLink(destination: fakeView1(testValue: $testValue),
							   tag: Navigator.scrrenOne,
							   selection: $sessionObject.pushedScreen) {EmptyView()}
				
				NavigationLink(destination: Text("SCREEN TWO").navigationBarTitle("Detail", displayMode: .large),
							   tag: Navigator.scrrenTwo,
							   selection: $sessionObject.pushedScreen) {EmptyView()}
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
