//
//  DependencyInjections.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 27/11/20.
//
// https://www.kiloloco.com/articles/004-dependency-injection-via-property-wrappers/


import Foundation


protocol Injectable {}

@propertyWrapper
struct Inject<T: Injectable> {
	let wrappedValue: T
	
	init() {
		wrappedValue = Resolver.shared.resolve()
	}
}




class Resolver {
	private var storage = [String: Injectable]()
	
	static let shared = Resolver()
	private init() {}
	
	
	func add<T: Injectable>(_ injectable: T) {
		let key = String(reflecting: injectable)
		storage[key] = injectable
	}
	
	func resolve<T: Injectable>() -> T {
		let key = String(reflecting: T.self)
		
		guard let injectable = storage[key] as? T else {
			fatalError("\(key) has not been added as an injectable object.")
		}
		
		return injectable
	}
}




class DependencyManager {
	private let myDependency: MyDependency
	
	init() {
		self.myDependency = MyDependency()
		addDependencies()
	}
	
	private func addDependencies() {
		let resolver = Resolver.shared
		resolver.add(myDependency)
	}
}
