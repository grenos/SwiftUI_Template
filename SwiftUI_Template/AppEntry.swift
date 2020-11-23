//
//  AppEntry.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct AppEntry: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	
	func getUser () {
		sessionObject.listen()
	}
	
	var body: some View {
		Group {
			if (Persistence.isLoggedin) {
				Tabbar()
					.transition(.slide)
					.animation(.spring())
			}
			else {
				AuthView()
					.transition(.slide)
					.animation(.spring())
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
