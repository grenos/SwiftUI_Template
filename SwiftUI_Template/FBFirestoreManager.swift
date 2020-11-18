//
//  FBFirestoreManager.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 18/11/2020.
//


import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FBFirestoreManager {
	
	private init() {}
	
	static let shared = FBFirestoreManager()
	
	
	/**
	- returns: Void
	- throws: Error of type "FBError"
	- parameters:
	- path: Firestore DocumentReference
	- documnt: A Codable class (usually a model class)
	- merge: A boolean to flag merging with old document in database
	
	If the document does not exist, it will be created.
	If the document does exist, its contents will be overwritten with the newly provided data,
	unless you specify that the data should be merged into the existing document.
	*/
	func setWithDocumentId<T: Codable>(for path: DocumentReference,
									   document: T,
									   merge: Bool,
									   completion: @escaping (Result<Void.Type, FBError>) -> Void)
	{
		do {
			try path.setData(from: document, merge: merge) { _ in
				print("Succesfully set document to firestore")
				completion(.success(Void.self))
			}
		} catch let error {
			print("Error setting document: \(error)")
			completion(.failure(.genericOperationError))
		}
	}
	
	
	
	
	/**
	- returns: String
	- throws: Error of type "FBError"
	- parameters:
	- path: Firestore CollectionReference
	- documnt: A Codable class (usually a model class)
	
	Writes Document to Firestore. It autogeerates documentID. Can not merge - only for new documents
	*/
	func addDocument<T: Codable>(for path: CollectionReference,
								 document: T,
								 completion: @escaping (Result<String, FBError>) -> Void)
	{
		var ref: DocumentReference? = nil
		do {
			try ref = path.addDocument(from: document, completion: { _ in
				print("Document added with ID: \(ref!.documentID)")
				completion(.success(ref!.documentID))
			})
		} catch let error {
			print("Error setting document: \(error)")
			completion(.failure(.genericOperationError))
		}
	}
	
	
	
	
	/**
	- returns: Void
	- throws: Error of type "FBError"
	- parameters:
	- path: Firestore DocumentReference
	- documnt: A dictionary with the fields to update
	
	Examples:
	- field --> 					["capital": true]
	- timestamp --> 				["lastUpdated": FieldValue.serverTimestamp()]
	- nested objects --> 			["favorites.color": "Red"]
	- add element to array --> 		["regions": FieldValue.arrayUnion(["greater_virginia"])]
	- increment numeric value --> 	["population": FieldValue.increment(Int64(50))]
	- remove element from array -->	["regions": FieldValue.arrayRemove(["east_coast"])]
	*/
	func updateDocumentField(for path: DocumentReference,
							 document: [String : Any],
							 completion: @escaping (Result<Void.Type, FBError>) -> Void)
	{
		path.updateData(document) { error in
			if let error = error {
				print("Error updating document: \(error)")
				completion(.failure(.genericOperationError))
			} else {
				print("Succesfully updated document to firestore")
				completion(.success(Void.self))
			}
		}
	}
	
	

	
	
	/**
	- returns: Void
	- throws: Error of type "FBError"
	- parameters:
	- payload: a dictionary that contains arrays of categorized operations based on CRUD
				which in turn every array contains dictionaries
				with the document and path to operate to
	
	It can be used with set update or delete.
	*/
	func batchOperations(for payload: [String : [[String : Any]]],
						 completion: @escaping (Result<Void.Type, FBError>) -> Void)
	{
		let batch = db.batch()
		
		guard let create = payload["create"] else { return }
		guard let update = payload["update"] else { return }
		guard let delete = payload["delete"] else { return }
		
		for document in create {
			batch.setData(document["document"] as! [String : Any],
						  forDocument: document["path"] as! DocumentReference,
						  merge: document["merge"] as! Bool)
		}
		
		for document in update {
			batch.setData(document["document"] as! [String : Any],
						  forDocument: document["path"] as! DocumentReference)
		}
		
		for document in delete {
			batch.setData(document["document"] as! [String : Any],
						  forDocument: document["path"] as! DocumentReference)
		}
		
		batch.commit() { error in
			if let error = error {
				print("Error on batch operation: \(error)")
				completion(.failure(.genericOperationError))
			} else {
				print("Succesfully completed batch operation")
				completion(.success(Void.self))
			}
		}
	}
	

	
	
	
	/**
	- returns: Void
	- throws: Error of type "FBError"
	- parameters:
	- path: Firestore DocumentReference
	
	Deletes a document
	*/
	func deleteDocument(for path: DocumentReference,
						completion: @escaping (Result<Void.Type, FBError>) -> Void)
	{
		path.delete() { error in
			if let error = error {
				print("Error deleting document: \(error)")
				completion(.failure(.genericOperationError))
			} else {
				print("Document successfully removed!")
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	/**
	- returns: Void
	- throws: Error of type "FBError"
	- parameters:
	- path: Firestore DocumentReference
	- documentField: Document fiekd to be deleted
	
	Deletes a document field
	*/
	func deleteDocumentField(for path: DocumentReference,
							 documentField: [String : Any],
							 completion: @escaping (Result<Void.Type, FBError>) -> Void)
	{
		path.updateData(documentField) { error in
			if let error = error {
				print("Error deleting field: \(error)")
				completion(.failure(.genericOperationError))
			} else {
				print("Field successfully removed!")
				completion(.success(Void.self))
			}
		}
	}
	
	

	
}

