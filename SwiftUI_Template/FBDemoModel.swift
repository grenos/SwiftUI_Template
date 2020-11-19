//
//  FBDemoModel.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 18/11/2020.
//


import SwiftUI
import FirebaseFirestore

public struct FBDemoModel: Codable, Identifiable {
	
	public let id = UUID()
	let name: String
	let state: String?
	let isCapital: Bool?
	let age: Int64?
	
	enum CodingKeys: String, CodingKey {
		case name
		case state
		case isCapital = "capital"
		case age
	}
	
	
	// Decode a FBDemoModel document coming from Firestore
	static func castDocument(for document: DocumentSnapshot,
										completion: @escaping (Result<FBDemoModel, FBError>) -> Void)
	{
		let result = Result {
			try document.data(as: FBDemoModel.self)
		}
		switch result {
			case .success(let document):
				if let city = document {
					completion(.success(city))
				} else {
					print("Document does not exist")
					completion(.failure(.genericOperationError))
				}
			case .failure(let error):
				print("Error decoding city: \(error.localizedDescription)")
				completion(.failure(.genericOperationError))
		}
	}
	
	
	
	static func castDocuments(for collection: QuerySnapshot,
							  completion: @escaping (Result<[FBDemoModel], FBError>) -> Void)
	{
		var documents = [FBDemoModel]()
		
		for document in collection.documents {
			let result = Result {
				try document.data(as: FBDemoModel.self)
			}
			switch result {
				case .success(let document):
					if let city = document {
						documents.append(city)
					} else {
						print("Document does not exist")
					}
				case .failure(let error):
					print("Error decoding city: \(error.localizedDescription)")
					completion(.failure(.genericOperationError))
			}
		}
		completion(.success(documents))
	}
	

}
