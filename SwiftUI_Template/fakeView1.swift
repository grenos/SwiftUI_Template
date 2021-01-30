//
//  fakeView1.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 15/11/2020.
//

import SwiftUI
import Introspect


class MyDependency: Injectable {
	func doSomething() {
		print("Next level injection 💉")
	}
}


struct fakeView1: View {
	
	@EnvironmentObject var sessionObject: SessionObject
	
	@Inject var dependency: MyDependency
	
	func didAppear() {
//		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//			sessionObject.pushedScreen = Navigator.none
//		}
	}
	
	func didDisappear() {
		print("Disppear")
	}
	
	func willDisappear() {
		print("Will Disppear")
	}
	
	var body: some View {
		VStack {
			Button("Tap Me", action: dependency.doSomething)
			Text("FAKE VIEW RED")
				.padding(.bottom, 40)
			
			
			NavigationLink(destination: Text("Deep Linked").navigationBarTitle("Deep Linked", displayMode: .inline)) {
				Rectangle().fill(Color.green).frame(width: 100, height: 100)
			}
			
			NavigationLink(destination: Text("cazzi miei").navigationBarTitle("cazzi miei", displayMode: .inline)) {
				Rectangle().fill(Color.green).frame(width: 100, height: 100)
			}
		}
		.onAppear { didAppear() }
		.onDisappear { didDisappear() }
		.onWillDisappear { willDisappear() }
		.navigationBarTitle("Detail", displayMode: .inline)
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
			print("App entering in background")
		}
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
			print("App entering in foreground")
		}
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
			print("User Took a screenshot")
		}
		.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
			print("Keyboard is visible")
		}
		.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
			print("Keyboard is not visible")
		}
		
	}
}

struct fakeView1_Previews: PreviewProvider {
	static var previews: some View {
		fakeView1()
	}
}
