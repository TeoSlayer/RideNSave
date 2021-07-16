//
//  ContentView.swift
//  RideNSave
//
//  Created by Calin Teodor on 7/15/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData : UserData
    var body: some View {

        if(userData.loggedIn){
            MapHome().background(Color("Background")).environmentObject(LocationManager.shared)
        }
        if(!userData.loggedIn){
            Authentification().environmentObject(UserData.shared)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
