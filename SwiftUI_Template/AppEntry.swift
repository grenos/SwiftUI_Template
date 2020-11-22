//
//  AppEntry.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct AppEntry: View {
	
	@EnvironmentObject var globalState: GlobalState
	
	func getUser () {
		globalState.listen()
	}
	
    var body: some View {
		Group {
			if (globalState.session != nil) {
				Tabbar()
					.transition(.move(edge: .trailing))
					.animation(.spring())
			}
			else {
				AuthView()
					.transition(.move(edge: .trailing))
					.animation(.spring())
			}
		}
		.onAppear(){ getUser() }
    }
	
}

struct AppEntry_Previews: PreviewProvider {
    static var previews: some View {
		AppEntry().environmentObject(GlobalState())
    }
}
