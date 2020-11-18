//
//  FBDemoModel.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 18/11/2020.
//

import Foundation



public struct City: Codable {
	
	let name: String
	let state: String?
	let country: String?
	let isCapital: Bool?
	let population: Int64?
	
	enum CodingKeys: String, CodingKey {
		case name
		case state
		case country
		case isCapital = "capital"
		case population
	}
	
}
