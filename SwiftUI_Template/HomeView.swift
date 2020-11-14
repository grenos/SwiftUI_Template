//
//  HomeView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct HomeView: View {
	
	@EnvironmentObject var globalState: GlobalState
	@ObservedObject var model = HomeMV()
	
    var body: some View {
		VStack {
			Text(globalState.test)
				.padding()
				.onTapGesture(perform: {
					globalState.setValue(slice: StateSlice.test, value: "sex pistols", persist: true)
				})
			
			Text("Navigate to tab")
				.onTapGesture(perform: {
					globalState.setValue(slice: StateSlice.activeTab, value: TabItem.other)
				})
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		HomeView().environmentObject(GlobalState())

    }
}
