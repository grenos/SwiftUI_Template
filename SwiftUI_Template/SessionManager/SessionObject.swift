//
//  SessionObject.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn
import CryptoKit
import AuthenticationServices


class SessionObject: NSObject,
					 ObservableObject,
					 GIDSignInDelegate,
					 ASAuthorizationControllerPresentationContextProviding,
					 ASAuthorizationControllerDelegate {
	
	var onGoogleSigninCompletion: ((Result<Void.Type, FBAuthError>) -> Void)?
	var onAppleSigninCompletion: ((Result<Void.Type, FBAuthError>) -> Void)?
	// Unhashed nonce for apple signin
	var currentNonce: String?
	
	@Published var test: String = "default value"
	// tab navigation
	@Published var selectedTabItem: TabItem = TabItem.home
	// Navigator
	@Published var pushedScreen: Navigator? = Navigator.none
	// auth session
	@Published var user: User? = nil
	@Published var authListener: AuthStateDidChangeListenerHandle? = nil
	@Published var isNewUser: Bool = true
	
	
	override init() {
		super.init()
		GIDSignIn.sharedInstance().delegate = self
	}
}
