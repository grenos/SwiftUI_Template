//
//  TodoModel.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import Foundation

public struct TodoModel: Codable, Identifiable, Hashable {
	
	public let id = UUID()
	var userId: Int
	var todoId: Int
	var title: String
	var completed: Bool
	
	enum CodingKeys: String, CodingKey {
		case userId
		case todoId = "id"
		case title
		case completed
	}
}
