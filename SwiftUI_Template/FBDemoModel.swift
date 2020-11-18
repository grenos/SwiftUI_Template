//
//  FBDemoModel.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 18/11/2020.
//


import SwiftUI

public struct FBDemoModel: Codable {
	
	let name: String
	let state: String?
	let isCapital: Bool?
	let age: Int64?
	
	enum CodingKeys: String, CodingKey {
		case name
		case state
		case isCapital = "capital"
		case age
	}
	
}
