//
//  OtherView.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct OtherView: View {
	
	@EnvironmentObject var globalState: GlobalState
	@ObservedObject var model = OtherMV()
	
    var body: some View {
        Text("Hello, Other!")
    }
}

struct OtherView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView().environmentObject(GlobalState())
    }
}
