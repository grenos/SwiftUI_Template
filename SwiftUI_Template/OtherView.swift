//
//  OtherView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI
import FirebaseFirestore

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
						FBFirestoreManager.shared.setWithDocumentId(for: path, document: testDoc, merge: true) {_ in }
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
						let path = db.collection("testCollection").document("testDocument")
						FBFirestoreManager.shared.updateDocumentField(for: path, document: ["name": "Vas + Giuli"]) { _ in }
					}
				
				Text("Batch operations")
					.padding(.bottom, 10)
					.onTapGesture {
						let path = db.collection("testCollection").document("testDocument")
						let path1 = db.collection("testCollection").document("testDocument1")
						let path2 = db.collection("testCollection").document("testDocument2")
						
						let testDoc = [
							"name": "Sex Pistols",
							"state": nil,
							"isCapital": nil,
							"age": 69
						] as [String : Any?]
						
						let batch = [
							"create": [
								[
								"document": testDoc,
								"path": path,
								"merge": true
								]
							],
							"update": [
								[
								"document": ["state": "Hell"],
								"path": path1,
								]
							],
							"delete": [["path": path2]]
						]
						FBFirestoreManager.shared.batchOperations(for: batch) { _ in }
					}
				
				Text("Delete Document")
					.padding(.bottom, 10)
					.onTapGesture {
						let path = db.collection("testCollection").document("testDocument")
						FBFirestoreManager.shared.deleteDocument(for: path) { _ in }
					}
				
				Text("Delete Document field")
					.padding(.bottom, 10)
					.onTapGesture {
						let path = db.collection("testCollection").document("testDocument")
						FBFirestoreManager.shared.deleteDocumentField(for: path, documentField: ["age" : FieldValue.delete()]) { _ in }
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
