//
//  FBStorageManager.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 21/11/20.
//

import Foundation
import FirebaseStorage

class FBStorageManager {
	
	private init() {}
	
	static let shared = FBStorageManager()
	
	
	
	//MARK: - uploadLocalFile
	/**
	- returns: Double?
	- throws: Error of type "FBStorageError"
	- parameters:
	- file: url of file to upload
	- bucketId: bucket name
	- fileName: file name
	- observe: flag to obseve progress or not
	*/
	func uploadLocalFile(_ file: URL,
						 bucketId: String,
						 fileName: String,
						 observe: Bool,
						 completion: @escaping (Result<Double?, FBStorageError>) -> Void)
	{
		let bucketReference = storage.reference().child(bucketId)
		let name 			= fileName
		let uploadTask 		= bucketReference.child(name)
		let localFile 		= file
		let metadata 		= StorageMetadata()
		
		let observable = uploadTask.putFile(from: localFile, metadata: metadata) { (metadata, error) in
			if let error = error {
				print("error uploading file \(error.localizedDescription)")
				completion(.failure(.genericStorageError))
				return
			}
		}
		
		observable.observe(.progress) { snapshot in
			let uploadPercentage = snapshot.progress?.fractionCompleted
			if observe {
				completion(.success(uploadPercentage!))
			}
		}
	}
	
	
	
	
	//MARK: - downloadFileToLocal
	/**
	- returns: Void
	- throws: Error of type "FBStorageError"
	- parameters:
	- bucketId: bucket name
	- fileName: file name
	*/
	func downloadFileToLocal(bucketId: String,
							 fileName: String,
							 completion: @escaping (Result<Void.Type, FBStorageError>) -> Void)
	{
		let name 			= fileName
		let directoryPath 	= getDocumentsDirectory().appendingPathComponent(name)
		let downloadTask 	= storage.reference().child("\(bucketId)/\(name)")
		
		downloadTask.write(toFile: directoryPath) { url, error in
			if let error = error {
				print("Error saving to local directory: \(error.localizedDescription)")
				completion(.failure(.genericStorageError))
			}
			else {
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	
	//MARK: - deleteStorageFile
	/**
	- returns: Void
	- throws: Error of type "FBStorageError"
	- parameters:
	- bucketId: bucket name
	- fileName: file name
	*/
	func deleteStorageFile(bucketId: String,
						   fileName: String,
						   completion: @escaping (Result<Void.Type, FBStorageError>) -> Void)
	{
		let name 		= fileName
		let deleteTask 	= storage.reference().child("\(bucketId)/\(name)")
		
		deleteTask.delete { error in
			if let error = error {
				print("Error deleting file from Storage: \(error.localizedDescription)")
				completion(.failure(.genericStorageError))
			}
			else {
				completion(.success(Void.self))
			}
		}
	}
	
	
	
	
	
	//MARK: - uploadLocalFileWithUrl
	/**
	- returns: Double?
	- throws: Error of type "FBStorageError"
	- parameters:
	- file: url of file to upload
	- bucketId: bucket name
	- fileName: file name
	- withUrl: flag to return url ref of file in Storage
	*/
	func uploadLocalFileWithUrl(_ file: URL,
								bucketId: String,
								fileName: String,
								withUrl: Bool,
								completion: @escaping (Result<URL?, FBStorageError>) -> Void)
	{
		let bucketReference = storage.reference().child(bucketId)
		let name 			= fileName
		let uploadTask 		= bucketReference.child(name)
		let localFile 		= file
		let metadata 		= StorageMetadata()
		
		uploadTask.putFile(from: localFile, metadata: metadata) { (metadata, error) in
			if let error = error {
				print("error uploading file \(error.localizedDescription)")
				completion(.failure(.genericStorageError))
				return
			}
			
			if withUrl {
				uploadTask.downloadURL { (url, error) in
					guard let downloadURL = url else {
						print("Error getting Url reference")
						completion(.failure(.genericStorageError))
						return
					}
					completion(.success(downloadURL))
				}
			}
		}
	}
}
