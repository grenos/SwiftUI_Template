//
//  fakeView1.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI
import Introspect

struct fakeView1: View {
	
	@EnvironmentObject var sessionObject: SessionObject
		
	func didAppear() {
		print("Appear")
	}
	
	func didDisappear() {
		print("Disppear")
	}
	
	func willDisappear() {
		print("Will Disppear")
	}
	
    var body: some View {
		NavigationView {
			VStack {
				Spacer()
				Text("FAKE VIEW RED")
					.padding(.bottom, 40)
				
				

				
			}
		}
		.onAppear { didAppear() }
		.onDisappear { didDisappear() }
		.onWillDisappear { willDisappear() }
		.navigationBarTitle("Detail", displayMode: .inline)
	
	}
}

struct fakeView1_Previews: PreviewProvider {
    static var previews: some View {
        fakeView1()
    }
}
