//
//  NetworkManager.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import UIKit
import Alamofire

class NetworkManager {
	static let shared = NetworkManager()
	private let baseUrl = "https://jsonplaceholder.typicode.com"
	
	private init() {}
	
	
	
	//MARK: - simple get
	/**
	- returns: Todo item
	- throws: Error of type "GenericNetworkError"
	- parameters:
	- endpoint: url endpoint
	- id: Int - Item id to fetch
	
	Get's a todo item from the sever
	*/
	func get(with endpoint: String,
			 id: Int,
			 completion: @escaping(Result<TodoModel, GenericNetworkError>) -> Void)
	{
		let url = baseUrl + endpoint + "/\(id)"
		
		guard let validUrl = URL(string: url) else {
			completion(.failure(.genericError))
			return
		}
		
		AF.request(validUrl).responseDecodable(of: TodoModel.self) { response in
			if response.response?.statusCode != 200 {
				print("error with response status: \(String(describing: response.response?.statusCode))")
				completion(.failure(.genericError))
				return
			}
			
			if (response.error != nil) {
				print("Error getting item: \(String(describing: response.error)))")
				completion(.failure(.genericError))
			}
			else {
				let todo = try! response.result.get()
				completion(.success(todo))
			}
			
			
		}
	}
	
	
	
	
	//MARK: - get with params
	/**
	- returns: Array of posts
	- throws: Error of type "GenericNetworkError"
	- parameters:
	- endpoint: url endpoint
	- params: Generic Parameters
	
	GET with params
	*/
	func getWithParams<P: Encodable>(with endpoint: String,
									 params: P,
									 completion: @escaping(Result<[PostsModel], GenericNetworkError>) -> Void)
	{
		let url = baseUrl + endpoint
		
		guard let validUrl = URL(string: url) else {
			completion(.failure(.genericError))
			return
		}
		
		AF.request(validUrl,
				   method: .get,
				   parameters: params).responseDecodable(of: [PostsModel].self) { response in
					
					if response.response?.statusCode != 200 {
						print("error with response status: \(String(describing: response.response?.statusCode))")
						completion(.failure(.genericError))
						return
					}
					
					if (response.error != nil) {
						print("Error getting item: \(String(describing: response.error)))")
						completion(.failure(.genericError))
					}
					else {
						let post = try! response.result.get()
						completion(.success(post))
					}
				}
	}
	
	
	
	//MARK: - POST
	/**
	- returns: Added post
	- throws: Error of type "GenericNetworkError"
	- parameters:
	- endpoint: url endpoint
	- params: Generic Parameters
	
	GET with params
	*/
	func post<P: Encodable>(with endpoint: String,
							params: P,
							completion: @escaping(Result<PostsModel, GenericNetworkError>) -> Void)
	{
		let url = baseUrl + endpoint
		
		guard let validUrl = URL(string: url) else {
			completion(.failure(.genericError))
			return
		}
		
		AF.request(validUrl,
				   method: .post,
				   parameters: params,
				   encoder: JSONParameterEncoder.default).responseDecodable(of: PostsModel.self) { response in
			
					if response.response?.statusCode != 201 {
				print("error with response status: \(String(describing: response.response?.statusCode))")
				print(response)
				completion(.failure(.genericError))
				return
			}
			
			if (response.error != nil) {
				print("Error getting item: \(String(describing: response.error)))")
				completion(.failure(.genericError))
			}
			else {
				let post = try! response.result.get()
				completion(.success(post))
			}
		}
	}
	
	
}
