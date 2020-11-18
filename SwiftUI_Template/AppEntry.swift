//
//  AppEntry.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 14/11/2020.
//

import SwiftUI

struct AppEntry: View {
	
	@EnvironmentObject var globalState: GlobalState
		
    var body: some View {
		Tabbar()
    }
}

struct AppEntry_Previews: PreviewProvider {
    static var previews: some View {
		AppEntry().environmentObject(GlobalState())
    }
}
