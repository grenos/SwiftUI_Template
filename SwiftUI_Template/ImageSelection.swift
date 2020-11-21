//
//  ImageSelection.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 21/11/20.
//

import SwiftUI

struct ImageSelection: View {
	
	@State private var showingImagePicker = false
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
		FBStorageManager.shared.downloadFileToLocal(bucketId: "user1", fileName: "testImage.jpg") { error in
			if let error = error {
				print(error.rawValue)
			}
			print("Download Complete")
		}
	}
	
	
	
    var body: some View {
		
		VStack {
			
			Text("Open image library")
				.padding(.bottom, 20)
				.onTapGesture {
					showingImagePicker = true
				}
			
			Text("Download to local Directory")
				.padding(.bottom, 20)
				.onTapGesture {
					downloadToLocal()
				}
			
		}
		.navigationBarTitle("Image Picker")
		.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
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
