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
		}
    }
}



struct Tabbar_Previews: PreviewProvider {
	static var previews: some View {
		Tabbar().environmentObject(GlobalState())
	}
}

