//
//  AppEntry.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct AppEntry: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	private let manager = DependencyManager()
	
	func getUser () {
		sessionObject.listen()
	}
	
	var body: some View {
		Group {
			if (sessionObject.user != nil) {
				Tabbar()
//					.transition(.slide)
//					.animation(.spring())
			}
			else {
				AuthView()
					.frame(width: 300, height: 600)
					.background(Color.green)
//					.transition(.slide)
//					.animation(.spring())
			}
		}
		.onAppear(){ getUser() }
	}
	
}

struct AppEntry_Previews: PreviewProvider {
	static var previews: some View {
		AppEntry().environmentObject(SessionObject())
	}
}
