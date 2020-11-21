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
	
	
	
	
	//MARK: - setWithDocumentId
	/**
	- returns: Void
	- throws: Error of type "FBFirestoreError"
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
									   completion: @escaping (Result<Void.Type, FBFirestoreError>) -> Void)
	{
		do {
			try path.setData(from: document, merge: merge) { _ in
				print("Succesfully set document to firestore")
				completion(.success(Void.self))
			}
		} catch let error {
			print("Error setting document: \(error.localizedDescription)")
			completion(.failure(.genericFirestoreError))
		}
	}
	
	
	
	
	//MARK: - addDocument
	/**
	- returns: String
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore CollectionReference
	- documnt: A Codable class (usually a model class)
	
	Writes Document to Firestore. It autogeerates documentID. Can not merge - only for new documents
	*/
	func addDocument<T: Codable>(for path: CollectionReference,
								 document: T,
								 completion: @escaping (Result<String, FBFirestoreError>) -> Void)
	{
		var ref: DocumentReference? = nil
		do {
			try ref = path.addDocument(from: document, completion: { _ in
				print("Document added with ID: \(ref!.documentID)")
				completion(.success(ref!.documentID))
			})
		} catch let error {
			print("Error setting document: \(error.localizedDescription)")
			completion(.failure(.genericFirestoreError))
		}
	}
	
	
	
	
	//MARK: - updateDocumentField
	/**
	- returns: Void
	- throws: Error of type "FBFirestoreError"
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
							 completion: @escaping (Result<Void.Type, FBFirestoreError>) -> Void)
	{
		path.updateData(document) { error in
			if let error = error {
				print("Error updating document: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				print("Succesfully updated document to firestore")
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	
	//MARK: - batchOperations
	/**
	- returns: Void
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- payload: a dictionary that contains arrays of categorized operations based on CRUD
	which in turn every array contains dictionaries
	with the document and path to operate to
	
	It can be used with set update or delete.
	*/
	func batchOperations(for payload: [String : [[String : Any]] ],
						 completion: @escaping (Result<Void.Type, FBFirestoreError>) -> Void)
	{
		let batch = db.batch()
		
		if let create = payload["create"] {
			for document in create {
				batch.setData(document["document"] as! [String : Any],
							  forDocument: document["path"] as! DocumentReference,
							  merge: document["merge"] as! Bool)
			}
		}
		
		if let update = payload["update"] {
			for document in update {
				batch.updateData(document["document"] as! [String : Any],
								 forDocument: document["path"] as! DocumentReference)
			}
		}
		
		if let delete = payload["delete"] {
			for document in delete {
				batch.deleteDocument(document["path"] as! DocumentReference)
			}
		}
		
		batch.commit() { error in
			if let error = error {
				print("Error on batch operation: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				print("Succesfully completed batch operation")
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	
	//MARK: - deleteDocument
	/**
	- returns: Void
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore DocumentReference
	
	Deletes a document
	*/
	func deleteDocument(for path: DocumentReference,
						completion: @escaping (Result<Void.Type, FBFirestoreError>) -> Void)
	{
		path.delete() { error in
			if let error = error {
				print("Error deleting document: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				print("Document successfully removed!")
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	//MARK: - deleteDocumentField
	/**
	- returns: Void
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore DocumentReference
	- documentField: Document fiekd to be deleted
	
	Deletes a document field
	*/
	func deleteDocumentField(for path: DocumentReference,
							 documentField: [String : Any],
							 completion: @escaping (Result<Void.Type, FBFirestoreError>) -> Void)
	{
		path.updateData(documentField) { error in
			if let error = error {
				print("Error deleting field: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				print("Field successfully removed!")
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	//MARK: - getDocument
	/**
	- returns: DocumentSnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore DocumentReference
	
	Retrieves a single document from firestore
	*/
	func getDocument(for path: DocumentReference,
					 completion: @escaping (Result<DocumentSnapshot, FBFirestoreError>) -> Void)
	{
		path.getDocument { (document, error) in
			if let document = document, document.exists {
				completion(.success(document))
			} else {
				print("Document does not exist: \(String(describing: error?.localizedDescription))")
				completion(.failure(.genericFirestoreError))
			}
		}
	}
	
	
	
	//MARK: - getAllDocuments
	/**
	- returns: QuerySnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore CollectionReference
	
	Retrieves documents from firestore collection
	*/
	func getAllDocuments(for path: CollectionReference,
						 completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void)
	{
		path.getDocuments() { (querySnapshot, error) in
			if let error = error {
				print("Error getting documents: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				completion(.success(querySnapshot!))
			}
		}
	}
	
	
	
	//MARK: - listenForDocument
	/**
	- returns: DocumentSnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore DocumentReference
	
	Listens to a document in Firestore
	*/
	func listenForDocument(for path: DocumentReference,
						   completion: @escaping (Result<DocumentSnapshot, FBFirestoreError>) -> Void) -> ListenerRegistration?
	{
		path.addSnapshotListener { documentSnapshot, error in
			guard let document = documentSnapshot else {
				print("Error fetching document: \(String(describing: error?.localizedDescription))")
				completion(.failure(.genericFirestoreError))
				return
			}
			guard document.data() != nil else {
				print("Document data was empty.")
				completion(.failure(.genericFirestoreError))
				return
			}
			completion(.success(document))
		}
	}
	
	
	
	
	
	//MARK: - listenForAllDocuments
	/**
	- returns: QuerySnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore CollectionReference
	
	Listens to documents in Firestore collection
	*/
	func listenForAllDocuments(for path: CollectionReference,
							   completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void) -> ListenerRegistration?
	{
		path.addSnapshotListener { querySnapshot, error in
			if let error = error {
				print("Error listening for documents: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				completion(.success(querySnapshot!))
			}
		}
	}
	
	
	
	//MARK: - getDocumentsWithQuery
	/**
	- returns: QuerySnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore Query
	
	Retrieves documents from firestore collection
	*/
	func getDocumentsWithQuery(for path: Query,
							   completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void)
	{
		path.getDocuments() { (querySnapshot, error) in
			if let error = error {
				print("Error getting documents: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				completion(.success(querySnapshot!))
			}
		}
	}
	
	
	
	//MARK: - listenForDocumentsWithQuery
	/**
	- returns: QuerySnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore Query
	
	Listens to documents in Firestore collection
	*/
	func listenForDocumentsWithQuery(for path: Query,
									 completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void) -> ListenerRegistration?
	{
		path.addSnapshotListener { querySnapshot, error in
			if let error = error {
				print("Error listening for documents: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				completion(.success(querySnapshot!))
			}
		}
	}
	
	
	
	
	//MARK: - getSubCollectionWithQuery
	/**
	- returns: QuerySnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore Querry
	
	Retrieves documents from all firestore collections that have the same name
	*/
	func getSubCollectionWithQuery(for path: Query,
						 completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void)
	{
		path.getDocuments() { (querySnapshot, error) in
			if let error = error {
				print("Error getting documents: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				completion(.success(querySnapshot!))
			}
		}
	}
	
	
	
	
	
	//MARK: - listenForSubCollectionWithQuery
	/**
	- returns: QuerySnapshot
	- throws: Error of type "FBFirestoreError"
	- parameters:
	- path: Firestore Query
	
	Listens to documents in all Firestore subcollections that have the same name
	*/
	func listenForSubCollectionWithQuery(for path: Query,
									 completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void) -> ListenerRegistration?
	{
		path.addSnapshotListener { querySnapshot, error in
			if let error = error {
				print("Error listening for documents: \(error.localizedDescription)")
				completion(.failure(.genericFirestoreError))
			} else {
				completion(.success(querySnapshot!))
			}
		}
	}
	
	
	
//	func getAggregateDocuments(from path: , to: ,completion: @escaping (Result<QuerySnapshot, FBFirestoreError>) -> Void)
//	{
//
//	}
}

