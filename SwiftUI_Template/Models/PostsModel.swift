//
//  PostsModel.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import Foundation

public struct PostsModel: Codable, Identifiable, Hashable {
	
	public let id = UUID()
	var userId: Int
	var postId: Int
	var title: String
	var body: String
	
	enum CodingKeys: String, CodingKey {
		case userId
		case postId = "id"
		case title
		case body
	}
}
