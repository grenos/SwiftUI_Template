//
//  FakeModal.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI

struct FakeModal: View {
	
	@EnvironmentObject var globalState: GlobalState
	
	@Binding var isPresented: Bool
	
	func willAppear() {
	}
	
	func willDisappear() {
	}
	
	var body: some View {
		NavigationView {
			VStack {
				Text("FAKE VIEW MODAL")
					.padding(.bottom, 40)
				
				
				Text("Close Modal")
					.onTapGesture {
						self.isPresented.toggle()
					}
				
				
			}
			.onAppear { willAppear() }
			.onDisappear { willDisappear() }
			
		}
		.navigationBarTitle("Modal", displayMode: .inline)
		
	}
}

struct FakeModal_Previews: PreviewProvider {
    static var previews: some View {
        FakeModal(isPresented: .constant(true))
    }
}
