//
//  LoginWithAppleButton.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 28/11/20.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct LoginWithAppleButton: UIViewRepresentable {
	
	func makeUIView(context: Context) -> some UIView {
		return ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {}
	
}
