//
//  AuthView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 22/11/20.
//

import SwiftUI

struct AuthView: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	
	@State var email: String = ""
	@State var password: String = ""
	@State var loading = false
	@State var error = false
	
	func signIn () {
		loading = true
		error = false
		
		sessionObject.signIn(email: email, password: password) { result in
			switch result {
				case .success(_):
					self.email = ""
					self.password = ""
				case .failure(let error):
					self.error = true
					print(error.rawValue)
			}
		}
	}
	
	
	func signUp() {
		loading = true
		error = false
		
		sessionObject.signUp(email: email, password: password) { result in
			switch result {
				case .success(_):
					sessionObject.signIn(email: email, password: password) { result in
						switch result {
							case .success(_):
								self.email = ""
								self.password = ""
							case .failure(let error):
								self.error = true
								print(error.rawValue)
						}
					}
				case .failure(let error):
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
		}
	}
}

struct AuthView_Previews: PreviewProvider {
	static var previews: some View {
		AuthView()
	}
}
