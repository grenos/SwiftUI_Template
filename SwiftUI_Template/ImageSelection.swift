//
//  ImageSelection.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 21/11/20.
//

import SwiftUI

struct ImageSelection: View {
	
	@State private var showingImagePicker: Bool = false
	@State private var isUploadWithUrl: Bool = false
	@State private var inputImage: UIImage?
	@State private var imageLocalPath: URL?
	
	
	func loadImage() {
		if imageLocalPath != nil {
			FBStorageManager.shared.uploadLocalFile(
				imageLocalPath!, bucketId: "user1", fileName: "testImage.jpg",
				observe: true ) { result in
				switch result {
					case .success(let percentage):
						print(percentage!)
					case .failure(let error):
						print(error.rawValue)
				}
			}
		}
	}
	
	
	func downloadToLocal() {
		FBStorageManager.shared.downloadFileToLocal(bucketId: "user1", fileName: "testImage.jpg") { result in
			switch result {
				case .success(_):
					print("Download Complete")
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	
	func deleteFromStorage() {
		FBStorageManager.shared.deleteStorageFile(bucketId: "user1", fileName: "testImage.jpg") { result in
			switch result {
				case .success(_):
					print("File deleted succesfully")
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	
	func uploadWithUrl() {
		if imageLocalPath != nil {
			FBStorageManager.shared.uploadLocalFileWithUrl(
				imageLocalPath!, bucketId: "user1", fileName: "testImage.jpg",
				withUrl: true ) { result in
				switch result {
					case .success(let urlReference):
						print(urlReference!)
					case .failure(let error):
						print(error.rawValue)
				}
			}
		}
	}
	
	
	var body: some View {
		
		VStack {
			
			Text("Open image library and save to file to Storage")
				.padding(.bottom, 20)
				.onTapGesture {
					isUploadWithUrl = false
					showingImagePicker = true
				}
			
			Text("Download to local Directory")
				.padding(.bottom, 20)
				.onTapGesture {
					downloadToLocal()
				}
			
			Text("Delete file from Storage")
				.padding(.bottom, 20)
				.onTapGesture {
					deleteFromStorage()
				}
			
			Text("Upload with URL")
				.padding(.bottom, 20)
				.onTapGesture {
					isUploadWithUrl = true
					showingImagePicker = true
				}
			
		}
		.navigationBarTitle("Image Picker")
		.sheet(isPresented: $showingImagePicker, onDismiss: isUploadWithUrl ? uploadWithUrl : loadImage) {
			ImagePicker(image: $inputImage, imagePath: $imageLocalPath)
		}
		
		
	}
}


struct ImageSelection_Previews: PreviewProvider {
	static var previews: some View {
		ImageSelection()
	}
}






struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	@Binding var image: UIImage?
	@Binding var imagePath: URL?
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
	
	
	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let parent: ImagePicker
		
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
			if let uiImage = info[.originalImage] as? UIImage {
				parent.image = uiImage
			}
			
			if let imageLocalPath = info[.imageURL] as? URL {
				parent.imagePath = imageLocalPath
			}
			
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}
