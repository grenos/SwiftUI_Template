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
		print("Appear")
	}
	
	func didDisappear() {
		print("Disppear")
	}
	
	func willDisappear() {
		print("Will Disppear")
	}
	
    var body: some View {
		NavigationView {
			VStack {
				Button("Tap Me", action: dependency.doSomething)
				Spacer()
				Text("FAKE VIEW RED")
					.padding(.bottom, 40)
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
