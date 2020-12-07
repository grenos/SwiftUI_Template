//
//  ErrorHandler.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import Foundation


// has a value of string and conform to swift's error protocol
enum GenericNetworkError: String, Error {
	case genericError = "An error occured. Please try again!"
}
