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
	@State var documentListener: ListenerRegistration?
	@State var documentsListener: ListenerRegistration?
	
	
	func viewWillAppear() {}
	
	func viewWillDisappear() {
		self.documentListener?.remove()
		self.documentsListener?.remove()
	}
	
	var body: some View {
		
		NavigationView {
			
			ScrollView {
				
				Group {
					
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
							self.batchOperation()
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
					
				}
				
				Group {
					Text("Get Single document")
						.padding(.bottom, 10)
						.foregroundColor(.red)
						.onTapGesture {
							self.getSingleDocument()
						}
					
					
					Text("Get all documents in collection")
						.padding(.bottom, 10)
						.foregroundColor(.red)
						.onTapGesture {
							self.getAllDocsInCollection()
						}
					
					
					Text("Listen for changes in document")
						.padding(.bottom, 10)
						.foregroundColor(.red)
						.onTapGesture {
							self.listenSingleDocument()
						}
					
					Text("Listen all documents in collection")
						.padding(.bottom, 10)
						.foregroundColor(.red)
						.onTapGesture {
							self.listenAllDocumentsInCollection()
						}
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
				
				
				NavigationLink(destination: Text("SCREEN TWO").navigationBarTitle("Detail", displayMode: .large)) {
					Rectangle().fill(Color.green).frame(width: 100, height: 100)
				}
				
			}
			.onAppear { self.viewWillAppear() }
			.onDisappear { self.viewWillDisappear() }
		}
		
	}
}


extension OtherView {
	
	func batchOperation() {
		let path = db.collection("testCollection").document("testDocument")
		let path1 = db.collection("testCollection").document("testDocument1")
		let path2 = db.collection("testCollection").document("testDocument2")
		
		let testDoc = [
			"name": "Sex Pistols",
			"state": nil,
			"capital": nil,
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
	
	
	func getSingleDocument() {
		let path = db.collection("testCollection").document("testDocument")
		FBFirestoreManager.shared.getDocument(for: path) { result in
			switch result {
				case .success(let document):
					FBDemoModel.castDocument(for: document) { result in
						switch result {
							case .success(let document):
								print("document: \(document)")
							case .failure(let error):
								print("Error decoding city: \(error)")
						}
					}
				case .failure(let error):
					print("Error getting document: \(error)")
			}
		}
	}
	
	func getAllDocsInCollection() {
		let path = db.collection("testCollection")
		FBFirestoreManager.shared.getAllDocumentsInCollection(for: path) { result in
			switch result {
				case .success(let collection):
					FBDemoModel.castDocuments(for: collection) { result in
						switch result {
							case .success(let documentArray):
								print("document: \(documentArray)")
							case .failure(let error):
								print("Error decoding city: \(error)")
						}
					}
				case .failure(let error):
					print("Error getting collection: \(error)")
			}
		}
	}
	
	
	func listenSingleDocument() {
		let path = db.collection("testCollection").document("testDocument")
		self.documentListener = FBFirestoreManager.shared.listenForDocument(for: path, completion: { result in
			switch result {
				case .success(let document):
					FBDemoModel.castDocument(for: document) { result in
						switch result {
							case .success(let document):
								print("document listener: \(document)")
							case .failure(let error):
								print("Error decoding city: \(error)")
						}
					}
				case .failure(let error):
					print("Error getting document: \(error)")
			}
		})
	}
	
	
	func listenAllDocumentsInCollection() {
		let path = db.collection("testCollection")
		self.documentsListener = FBFirestoreManager.shared.listenAllDocumentsInCollection(for: path) { result in
			switch result {
				case .success(let collection):
					FBDemoModel.castDocuments(for: collection) { result in
						switch result {
							case .success(let documentArray):
								print("document: \(documentArray)")
							case .failure(let error):
								print("Error decoding city: \(error)")
						}
					}
				case .failure(let error):
					print("Error getting collection: \(error)")
			}
		}
	}
	
}



struct OtherView_Previews: PreviewProvider {
	static var previews: some View {
		OtherView().environmentObject(GlobalState())
	}
}
