//
//  Tabbar.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

enum TabItem: Hashable {
	case home
	case other
	case star
	case camera
}

struct Tabbar: View {
	
	@EnvironmentObject var globalState: GlobalState
		
    var body: some View {
	
		TabView(selection: $globalState.selectedTabItem) {
			HomeView()
				.tabItem {
					Image(systemName: globalState.selectedTabItem == TabItem.home ? "house.fill" : "house")
					Text("Home")
				}
				.tag(TabItem.home)
				
			OtherView()
				.tabItem {
					Image(systemName: globalState.selectedTabItem == TabItem.other ? "folder.fill" : "folder")
					Text("Other")
				}
				.tag(TabItem.other)
			
			MultiView()
				.tabItem {
					Image(systemName: globalState.selectedTabItem == TabItem.star ? "star.fill" : "star")
					Text("Star")
				}
				.tag(TabItem.star)
			
			ImageSelection()
				.tabItem {
					Image(systemName: globalState.selectedTabItem == TabItem.star ? "camera.fill" : "camera")
					Text("Photo")
				}
				.tag(TabItem.camera)
		}
    }
}



struct Tabbar_Previews: PreviewProvider {
	static var previews: some View {
		Tabbar().environmentObject(GlobalState())
	}
}

