//
//  FakeModal.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI

struct FakeModal: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	
	@Binding var isPresented: Bool
	@Binding var newViewShowing: Bool
	
	func willAppear() {
	}
	
	func willDisappear() {
	}
	
	func getTodo() {
		NetworkManager.shared.get(with: Endpoints.todo.rawValue, id: 10) { result in
			switch result {
				case .success(let todo):
					print(todo.title)
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	func getTodoWithParams() {
		let userId = GetWithParmas(userId: 1)
		NetworkManager.shared.getWithParams(with: Endpoints.posts.rawValue, params: userId) { result in
			switch result {
				case .success(let posts):
					print(posts[0])
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	func postPosts() {
		let post = PostsModel(userId: 666, postId: 1, title: "Sex Pistols", body: "H Alithia vriskete stous sex pistols.")
		NetworkManager.shared.post(with: Endpoints.posts.rawValue, params: post) { result in
			switch result {
				case .success(let post):
					print(post)
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	
	func updatePost() {
		let post = PostsModel(userId: 666, postId: 1, title: "Zhu", body: "Some other lyrics.")
		NetworkManager.shared.update(with: Endpoints.posts.rawValue, params: post, postId: 1) { result in
			switch result {
				case .success(let post):
					print(post)
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	
	func deletePost() {
		NetworkManager.shared.delete(with: Endpoints.posts.rawValue, postId: 1) { result in
			switch result {
				case .success(_):
					print("Post deleted")
				case .failure(let error):
					print(error.rawValue)
			}
		}
	}
	
	
	var body: some View {
		NavigationView {
			VStack {
				Text("FAKE VIEW MODAL")
					.padding(.bottom, 40)
				
				Text("Simple GET")
					.padding(.bottom, 40)
					.onTapGesture {
						getTodo()
					}
				
				Text("GET with params")
					.padding(.bottom, 40)
					.onTapGesture {
						getTodoWithParams()
					}
				
				Text("POST")
					.padding(.bottom, 40)
					.onTapGesture {
						postPosts()
					}
				
				Text("PUT - UPDATE")
					.padding(.bottom, 40)
					.onTapGesture {
						updatePost()
					}
				
				Text("DELETE")
					.padding(.bottom, 40)
					.onTapGesture {
						deletePost()
					}
				
				Text("Close Modal")
					.font(.headline)
					.padding(.bottom, 40)
					.onTapGesture {
						self.isPresented.toggle()
					}
				
				
				
				// this will close the current opend modal
				// returning the user to the previews view
				// and it will navigate to a new (declared in the previews view)
				Button("Go to new view") {
					newViewShowing.toggle()
					isPresented.toggle()
				}.padding()
				
				
				// this will navigate to a new inside the modal
				// turning back from that view returns to the modal
				// the modal in that case needs to be a fullCover modal
				NavigationLink(destination: Text("SCREEN TWO").navigationBarTitle("Detail", displayMode: .large)) {
					Rectangle().fill(Color.green).frame(width: 100, height: 100)
				}
								
			}
			.onAppear { willAppear() }
			.onDisappear { willDisappear() }
			
		}
		.navigationBarTitle("Modal", displayMode: .inline)
		
	}
}

struct FakeModal_Previews: PreviewProvider {
	static var previews: some View {
		FakeModal(isPresented: .constant(true), newViewShowing: .constant(true))
	}
}
