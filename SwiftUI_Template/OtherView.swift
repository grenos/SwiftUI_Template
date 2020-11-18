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
				
				
				Text("Set Document")
					.padding(.bottom, 10)
					.onTapGesture {
						let path = db.collection("testCollection").document("testDocument")
						let testDoc = FBDemoModel(
							name: "Vas",
							state: nil,
							isCapital: nil,
							age: 35
						)
						FBFirestoreManager.shared.setWithDocumentId(for: path, document: testDoc, merge: true) { _ in
						}
					}
				
				Text("Add Document")
					.padding(.bottom, 10)
					.onTapGesture {
						let path = db.collection("testCollection")
						let testDoc = FBDemoModel(
							name: "Vas",
							state: nil,
							isCapital: nil,
							age: 35
						)
						FBFirestoreManager.shared.addDocument(for: path, document: testDoc) { _ in
						}
					}
				
				Text("Update Document field")
					.padding(.bottom, 10)
					.onTapGesture {
						
					}
				
				Text("Batch operations")
					.padding(.bottom, 10)
					.onTapGesture {
						
					}
				
				Text("Delete Document")
					.padding(.bottom, 10)
					.onTapGesture {
						
					}
				
				Text("Delete Document field")
					.padding(.bottom, 10)
					.onTapGesture {
						
					}
				
				
				
				
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

				
				NavigationLink(destination: Text("SCREEN TWO").navigationBarTitle("Detail", displayMode: .large)) { Rectangle().fill(Color.green).frame(width: 100, height: 100) }
			}
		}
	
	}
}

struct OtherView_Previews: PreviewProvider {
	static var previews: some View {
		OtherView().environmentObject(GlobalState())
	}
}
