//
//  MultiView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI

struct MultiView: View {
	
	@State private var index = 0
	
	var body: some View {
		
		VStack {
			
				// Tab View...
				
				HStack(spacing: 0){
					
					Text("First Tab")
						.foregroundColor(self.index == 0 ? .purple : .white)
						.fontWeight(.bold)
						.padding(.vertical,10)
						.padding(.horizontal,35)
						.background(Color("Color").opacity(self.index == 0 ? 1 : 0))
						.clipShape(Capsule())
						.onTapGesture {
							
							withAnimation(.default){
								
								self.index = 0
							}
						}
					
					Spacer(minLength: 0)
					
					Text("Second Tap")
						.foregroundColor(index == 1 ? .purple : .white)
						.fontWeight(.bold)
						.padding(.vertical,10)
						.padding(.horizontal,35)
						.background(Color("Color").opacity(index == 1 ? 1 : 0))
						.clipShape(Capsule())
						.onTapGesture {
							
							withAnimation(.default){
								
								self.index = 1
							}
						}
					
					Spacer(minLength: 0)
					
					Text("Thrid Tab")
						.foregroundColor(index == 2 ? .purple : .white)
						.fontWeight(.bold)
						.padding(.vertical,10)
						.padding(.horizontal,35)
						.background(Color("Color").opacity(index == 2 ? 1 : 0))
						.clipShape(Capsule())
						.onTapGesture {
							
							withAnimation(.default){
								
								self.index = 2
							}
						}
				}
				.background(Color.orange)
				.clipShape(Capsule())
				.padding(.horizontal)
				.padding(.top,25)
				
				
				TabView(selection: $index) {
					Text("First Tab").tabItem {
						Image(systemName: (index == 0 ? "house.fill" : "house"))
						Text("Home")
					}
					.tag(0)
					
					Text("Second Tab").tabItem {
						Image(systemName: (index == 1 ? "plus.circle.fill" : "plus.circle"))
						Text("Add")
					}
					.tag(1)
					
					Text("Third Tab").tabItem {
						Image(systemName: (index == 2 ? "heart.fill" : "heart"))
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
