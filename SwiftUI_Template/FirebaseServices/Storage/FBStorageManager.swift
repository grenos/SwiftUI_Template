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
		let name = fileName
		let uploadTask = bucketReference.child(name)
		let localFile = file
		let metadata = StorageMetadata()

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
	
	
	
	
	
	
	func downloadFileToLocal() {
		

		// Create a reference to the file you want to download
		let islandRef = storage.reference().child("images/island.jpg")
		// Create local filesystem URL
		let localURL = URL(string: "path/to/image")!
		// Download to the local filesystem
		let downloadTask = islandRef.write(toFile: localURL) { url, error in
			if let error = error {
				// Uh-oh, an error occurred!
			} else {
				// Local file URL for "images/island.jpg" is returned
			}
		}

		
		
	}
	
	
	
	func addToStorage(with image: UIImage, itemId: String ) {
		


		
		//MARK: Delete file from storage
		// Create a reference to the file to delete
		let desertRef = storage.reference().child("desert.jpg")
		// Delete the file
		desertRef.delete { error in
			if let error = error {
				// Uh-oh, an error occurred!
			} else {
				// File deleted successfully
			}
		}
		
			
		
		let bucket							= storage.reference().child("userAvatars")
		let itemName						= itemId + "_avatar.jpg"
		let uploadImageURL 					= bucket.child(itemName)
		let metadata 						= StorageMetadata()
		metadata.contentType 				= "image/jpeg"
		guard let convertedAvatarForUpload 	= image.jpegData(compressionQuality: 0.8) else {
			print("Error converting iamge")
			return
		}
		
		
		uploadImageURL.putData(convertedAvatarForUpload, metadata: metadata) { (metadata, error) in
			guard let _ = metadata else {
				print("ERROR UPLOADING IMAGE")
				return
			}
			
			
			//MARK: download URL
			// get url reference of the image
			uploadImageURL.downloadURL { (url, error) in
				guard let downloadURL = url else {
					print("ERROR GETTING IMAGE URL")
					return
				}
				
			}
						
		
			// MARK: Download file to memory
			// Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
			uploadImageURL.getData(maxSize: 1 * 1024 * 1024) { data, error in
				if let error = error {
					// Uh-oh, an error occurred!
				} else {
					// Data for "images/island.jpg" is returned
					let image = UIImage(data: data!)
				}
			}
	
		}

		
	}

	
	
	
	
	
	func listAllPaginated(pageToken: String? = nil) {
		let storage = Storage.storage()
		let storageReference = storage.reference().child("files/uid")
		
		let pageHandler: (StorageListResult, Error?) -> Void = { (result, error) in
			if let error = error {
				// ...
			}
			let prefixes = result.prefixes
			let items = result.items
			
			// ...
			
			// Process next page
			if let token = result.pageToken {
				self.listAllPaginated(pageToken: token)
			}
		}
		
		if let pageToken = pageToken {
			storageReference.list(withMaxResults: 100, pageToken: pageToken, completion: pageHandler)
		} else {
			storageReference.list(withMaxResults: 100, completion: pageHandler)
		}
	}
	
	
	
	
}
