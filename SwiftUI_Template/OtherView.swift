//
//  OtherView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct OtherView: View {
	
	@EnvironmentObject var globalState: GlobalState
	
	var body: some View {
		
		NavigationView {
			VStack {
				Text("Hello, Other!")
					.navigationBarTitle("Other", displayMode: .inline)
				
				
				
				NavigationLink(destination: Text("SCREEN TWO")	.navigationBarTitle("Detail", displayMode: .large)) { Rectangle().fill(Color.green).frame(width: 100, height: 100) }
			}
		}
	
		
		
		
		.introspectTabBarController { (UITabBarController) in
			UITabBarController.tabBar.isHidden = false
		}
	}
}

struct OtherView_Previews: PreviewProvider {
	static var previews: some View {
		OtherView().environmentObject(GlobalState())
	}
}
