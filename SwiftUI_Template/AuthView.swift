//
//  AuthView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 22/11/20.
//

import SwiftUI

struct AuthView: View {
	
	@EnvironmentObject var globalState: GlobalState
	
	@State var email: String = ""
	@State var password: String = ""
	@State var loading = false
	@State var error = false
	
	func signIn () {
		loading = true
		error = false
		globalState.signIn(email: email, password: password) { (result, error) in
			self.loading = false
			if error != nil {
				self.error = true
			} else {
				self.email = ""
				self.password = ""
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
		}
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
		AuthView()
    }
}
