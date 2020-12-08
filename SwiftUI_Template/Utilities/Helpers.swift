//
//  Helpers.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import SwiftUI


class Helpers {
	
	static let shared = Helpers()
	
	private init() {}
	
	public func getScreenSize() -> CGRect{
		return UIScreen.main.bounds
	}
}
