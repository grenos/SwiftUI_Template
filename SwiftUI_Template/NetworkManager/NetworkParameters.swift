//
//  NetworkParameters.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import Foundation


enum Endpoints: String {
	case todo = "/todos"
	case posts = "/posts"
}


struct GetWithParmas: Encodable {
	var userId: Int
}
