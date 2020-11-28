//
//  UserDefaults.swift
//  Delich
//
//  Created by Vasileios Gkreen on 15/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation


@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    	
	var wrappedValue: T {
		get {
			
			if let data = UserDefaults.standard.object(forKey: key) as? Data,
			   let user = try? JSONDecoder().decode(T.self, from: data) {
				return user
				
			}
			
			return  defaultValue
		}
		set {
			if let encoded = try? JSONEncoder().encode(newValue) {
				UserDefaults.standard.set(encoded, forKey: key)
			}
		}
	}
}



struct Persistence {
    @UserDefault("is_google_user", defaultValue: false)
    static var isGoogleUser: Bool
	
	@UserDefault("is_apple_user", defaultValue: false)
	static var isAppleUser: Bool
	
	@UserDefault("is_facebook_user", defaultValue: false)
	static var isFacebookUser: Bool
	
	@UserDefault("is_email_user", defaultValue: false)
	static var isEmailUser: Bool
	
	@UserDefault("test", defaultValue: "")
	static var test: String
    
	@UserDefault("followers", defaultValue: [String : String]())
	static var followers: [String : String]
	
}
