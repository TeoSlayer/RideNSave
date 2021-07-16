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
            Home().background(Color("Background")).environmentObject(LocationManager.shared)
        }
        if(!userData.loggedIn){
            Authentification()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
