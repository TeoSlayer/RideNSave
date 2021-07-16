//
//  RideNSaveApp.swift
//  RideNSave
//
//  Created by Calin Teodor on 7/15/21.
//

import SwiftUI
import Firebase

@main
struct RideNSaveApp: App {
    // or .dark

    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserData.shared).environment(\.colorScheme, .dark) 
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        if(Auth.auth().currentUser?.uid != nil){
            UserData.shared.retrieveUser(userId: Auth.auth().currentUser?.uid ?? "")
        }
       

      return true
    }
}

