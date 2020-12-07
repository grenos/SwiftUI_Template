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
				
				Text("Close Modal")
					.font(.headline)
					.padding(.bottom, 40)
					.onTapGesture {
						self.isPresented.toggle()
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
		FakeModal(isPresented: .constant(true))
	}
}
