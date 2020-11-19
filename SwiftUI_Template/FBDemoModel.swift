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
	
	
	func castFirestoreDocument(for document: DocumentSnapshot,
							   completion: @escaping (Result<FBDemoModel.Type, FBError>) -> Void)
	{
		let result = Result {
			try document.data(as: FBDemoModel.self)
		}
		switch result {
			case .success(let document):
				if let city = document {
					// A `City` value was successfully initialized from the DocumentSnapshot.
					print("City: \(city)")
				} else {
					// A nil value was successfully initialized from the DocumentSnapshot,
					// or the DocumentSnapshot was nil.
					print("Document does not exist")
				}
			case .failure(let error):
				// A `City` value could not be initialized from the DocumentSnapshot.
				print("Error decoding city: \(error)")
		}
	}
	
}
