//
//  AuthView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 22/11/20.
//

import SwiftUI
import GoogleSignIn

struct AuthView: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	
	@State var email: String = ""
	@State var password: String = ""
	@State var loading = false
	@State var error = false
	
	func signIn () {
		self.loading = true
		self.error = false
		
		sessionObject.signIn(email: email, password: password) { result in
			switch result {
				case .success(_):
					self.email = ""
					self.password = ""
					self.loading = false
				case .failure(let error):
					self.loading = false
					self.error = true
					print(error.rawValue)
			}
		}
	}
	
	
	func signUp() {
		self.loading = true
		self.error = false
		
		sessionObject.signUp(email: email, password: password) { result in
			switch result {
				case .success(_):
					sessionObject.signIn(email: email, password: password) { result in
						switch result {
							case .success(_):
								self.email = ""
								self.password = ""
								self.loading = false
							case .failure(let error):
								self.loading = false
								self.error = true
								print(error.rawValue)
						}
					}
				case .failure(let error):
					self.loading = false
					self.error = true
					print(error.rawValue)
			}
		}
	}
	
	
	func googleLogin() {
		self.loading = true
		self.error = false
		sessionObject.loginWithGoogle { result in
			switch result {
				case .success(_):
					self.loading = false
					self.error = false
				case .failure(let error):
					self.loading = false
					self.error = true
					print(error.rawValue)
			}
		}
	}
	
	
	func facebookLogin() {
		self.loading = true
		self.error = false
		sessionObject.LoginWithFacebook { result in
			switch result {
				case .success(_):
					self.loading = false
					self.error = false
				case .failure(let error):
					self.loading = false
					self.error = true
					print(error.rawValue)
			}
		}
	}
	
	
	var body: some View {
		VStack {
			TextField("email address", text: $email)
			TextField("Password", text: $password)
			if (error) {
				Text("ahhh crap")
			}
			
			Button(action: signIn) {
				Text("Sign in")
			}
			.padding()
			
			Button(action: signUp) {
				Text("Sign up")
			}
			.padding()
			
			
			Button(action: googleLogin) {
				Text("Login With Google")
			}
			.padding()
			
			Button(action: facebookLogin) {
				Text("Login With Facebook")
			}
			.padding()
			
			
			LoginWithAppleButton()
				.frame(width: 280, height: 55)
				.padding()
				.onTapGesture {
					sessionObject.startSignInWithAppleFlow { _ in
						print("SIGN IN WITH APPLE")
					}
				}
		}
	}
}

struct AuthView_Previews: PreviewProvider {
	static var previews: some View {
		AuthView()
	}
}

