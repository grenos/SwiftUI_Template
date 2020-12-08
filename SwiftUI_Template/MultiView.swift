//
//  MultiView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI

struct MultiView: View {
	
	@State private var selected = 0
	
	var body: some View {
		
		NavigationView {
			ZStack {
				TabNavigationView(selected: $selected)
				MultiViewPages(selected: $selected)
			}
		}
	}
}


struct TabNavigationView: View {
	
	@Binding var selected: Int
	@Namespace private var animation
	
	let categories = ["First", "Second", "Third"]
	
	var body: some View {
		VStack() {
			HStack(spacing: 15){
				ForEach(categories.indices, id: \.self) { index in
					let currentCategory = self.categories[index]
					
					Button {
						withAnimation {
							selected = index
						}
					} label: {
						VStack(spacing: 5) {
							Text(currentCategory)
								.font(.system(size: 18))
								.fontWeight(.semibold)
								.padding(.bottom, 5)
								.matchedGeometryEffect(id: index, in: animation, isSource: true)
						}.accentColor(.primary)
					}.overlay(
						RoundedRectangle(cornerRadius: 5)
							.frame(height: 2)
							.matchedGeometryEffect(id: selected, in: animation, isSource: false)
					)
				}
				Spacer()
			}
			.padding(.leading)
			.frame(width: Helpers.shared.getScreenSize().width)
			
			Spacer()
		}
		.navigationTitle("Tabs")
		.zIndex(2)
	}
}



struct MultiViewPages: View {
	
	@Binding var selected: Int
	
	var body: some View {
		VStack {
			TabView(selection: $selected) {
				Text("First Tab").tabItem {
					Image(systemName: (selected == 0 ? "house.fill" : "house"))
					Text("Home")
				}
				.tag(0)
				
				Text("Second Tab").tabItem {
					Image(systemName: (selected == 1 ? "plus.circle.fill" : "plus.circle"))
					Text("Add")
				}
				.tag(1)
				
				Text("Third Tab").tabItem {
					Image(systemName: (selected == 2 ? "heart.fill" : "heart"))
					Text("Favorite")
				}
				.tag(2)
			}
		}
		.tabViewStyle(PageTabViewStyle())
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
	}
}



struct MultiView_Previews: PreviewProvider {
	static var previews: some View {
		MultiView()
	}
}
