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
	case photo
}

struct Tabbar: View {
	
	@EnvironmentObject var sessionObject: SessionObject
		
    var body: some View {
	
		TabView(selection: $sessionObject.selectedTabItem) {
			HomeView()
				.tabItem {
					Image(systemName: sessionObject.selectedTabItem == TabItem.home ? "house.fill" : "house")
					Text("Home")
				}
				.tag(TabItem.home)
				
			OtherView()
				.tabItem {
					Image(systemName: sessionObject.selectedTabItem == TabItem.other ? "folder.fill" : "folder")
					Text("Other")
				}
				.tag(TabItem.other)
			
			MultiView()
				.tabItem {
					Image(systemName: sessionObject.selectedTabItem == TabItem.star ? "star.fill" : "star")
					Text("Star")
				}
				.tag(TabItem.star)
			
			ImageSelection()
				.tabItem {
					Image(systemName: sessionObject.selectedTabItem == TabItem.camera ? "photo.fill" : "photo")
					Text("Photo")
				}
				.tag(TabItem.photo)
			
			CameraView()
				.tabItem {
					Image(systemName: sessionObject.selectedTabItem == TabItem.camera ? "camera.fill" : "camera")
					Text("Camera")
				}
				.tag(TabItem.camera)
		}
    }
}



struct Tabbar_Previews: PreviewProvider {
	static var previews: some View {
		Tabbar().environmentObject(SessionObject())
	}
}

