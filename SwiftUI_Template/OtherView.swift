//
//  OtherView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct OtherView: View {
	
	@EnvironmentObject var globalState: GlobalState
	
	@State var isPresented: Bool = false
	
	var body: some View {
		
		NavigationView {
			VStack {
				Text("Hello, Other!")
					.navigationBarTitle("Other", displayMode: .inline)
				
				
				Button {
					self.isPresented.toggle()
				} label: {
					Text("open modal")
				}.sheet(isPresented: $isPresented) {
					FakeModal(isPresented: $isPresented)
				}
				.padding()

				
				NavigationLink(destination: Text("SCREEN TWO")	.navigationBarTitle("Detail", displayMode: .large)) { Rectangle().fill(Color.green).frame(width: 100, height: 100) }
			}
		}
	
	}
}

struct OtherView_Previews: PreviewProvider {
	static var previews: some View {
		OtherView().environmentObject(GlobalState())
	}
}
