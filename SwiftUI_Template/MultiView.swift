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
			VStack {
//				TabNavigationView(selected: $selected)
				MultiViewPages(selected: $selected)
			}
			.navigationTitle("Tabs")
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
//		.navigationTitle("Tabs")
//		.zIndex(2)
	}
}



struct MultiViewPages: View {
	
	@Binding var selected: Int
	
	var body: some View {
			TabView(selection: $selected) {
				Text("First Tab").tabItem {
					Text("Home")
				}
				.tag(0)
				.background(Color.red)
				
				Text("Second Tab").tabItem {
					Text("Add")
				}
				.background(Color.green)
				.tag(1)
				
				Text("Third Tab").tabItem {
					Text("Favorite")
				}
				.tag(2)
				.background(Color.yellow)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
	}
}



struct MultiView_Previews: PreviewProvider {
	static var previews: some View {
		MultiView()
	}
}
