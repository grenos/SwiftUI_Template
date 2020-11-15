//
//  fakeView1.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI
import Introspect

struct fakeView1: View {
	
	@EnvironmentObject var globalState: GlobalState
		
	func willAppear() {
		globalState.setValue(slice: StateSlice.hideTab, value: true)
	}
	
	func willDisappear() {
		globalState.setValue(slice: StateSlice.hideTab, value: false)
	}
	
    var body: some View {
		NavigationView {
			VStack {
				Spacer()
				Text("FAKE VIEW RED")
					.padding(.bottom, 40)
				
				

				
			}
			.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
			.edgesIgnoringSafeArea(.all)
			.background(Color.red)
			
			.onAppear { willAppear() }
			.onDisappear { willDisappear() }
			.introspectTabBarController() { (UITabBarController) in
				UITabBarController.tabBar.isHidden = globalState.hideTabbar
			}
			
			
			
			
		}
		.navigationBarTitle("Detail", displayMode: .inline)
	
	}
}

struct fakeView1_Previews: PreviewProvider {
    static var previews: some View {
        fakeView1()
    }
}
