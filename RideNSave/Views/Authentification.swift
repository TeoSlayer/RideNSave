//
//  Authentification.swift
//  RideNSave
//
//  Created by Calin Teodor on 15.07.2021.
//

import SwiftUI

struct Authentification: View {
    @EnvironmentObject var userData : UserData
    var body: some View {
        if(!userData.Onboarding && !userData.LoggingIn){
            Splashscreen(Login: $userData.LoggingIn).animation(.easeIn)
        }
        if(!userData.Onboarding && userData.LoggingIn){
            Login(Login: $userData.LoggingIn, Onboarding: $userData.Onboarding).animation(.easeIn)
        }
        if(userData.Onboarding && !userData.LoggingIn){
            Onboard(onboard: $userData.Onboarding)
        }
    }
}

struct Authentification_Previews: PreviewProvider {
    static var previews: some View {
        Authentification()
    }
}
