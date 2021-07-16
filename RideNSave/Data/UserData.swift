//
//  UserData.swift
//  RideNSave
//
//  Created by Calin Teodor on 15.07.2021.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import MapKit
class UserData : ObservableObject{
    @Published var loggedIn : Bool = Auth.auth().currentUser?.uid != nil ? true : false
    let settings = FirestoreSettings()
    let db = Firestore.firestore()
    @Published var user : User?
    @Published var Onboarding : Bool = false
    @Published var LoggingIn : Bool = false

    
    func SignIn() {
        self.loggedIn = true
        UserDefaults.standard.set(true, forKey: "loggedin")
    }
    
    func SignOut(){
        UserDefaults.standard.set(false, forKey: "loggedin")
        self.loggedIn = false
        self.purgeData()
    }
    
    func retrieveUser(userId: String){
        db.settings.isPersistenceEnabled = true
        let userdbref = db.collection("Users").document(userId)
        var listner = userdbref.addSnapshotListener{ [self] (snapshot, err) in
            if var data = snapshot?.data() {
                var dbuser = User(id: userId, Email: data["Email"] as? String ?? "", Name: data["Name"] as? String ?? "", Preffered:  data["Preffered"] as? Int ?? 0, ProfilePicture: data["ProfilePicture"] as? Int ?? 0)
                self.user = dbuser
                self.loggedIn = true
                self.Onboarding = false
                self.LoggingIn = false
            } else {
                print("Couldn't find the document")
            }
        }
    }
    
    func checkIfUserExists(id: String,completion: @escaping (Bool) -> ()){
        let userdbref = db.collection("Users").document(id)
        userdbref.getDocument(completion: {(document, err) in
            if let document = document, document.exists{
                self.retrieveUser(userId: id)
                completion(true)
            }
            else{
                print("User does not exist")
                completion(false)
            }
        })
    }
    
    func pushUser(id: String,name: String, email: String, preffered: Int, profilepicture : Int){
        let userdbref = db.collection("Users").document(id).setData([
            "ID" : id,
            "Name" : name,
            "Email" : email,
            "Preffered" : preffered,
            "ProfilePicture" : profilepicture
        ]){err in
            if let err = err{
                print("Error during uploading document to firebase")
            }else{
                self.retrieveUser(userId: id)

            }
        }
    }
    
    func listenForAuth(){
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                self.retrieveUser(userId: user!.uid)
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.purgeData()
                })
            }
        }
    }
    
    func purgeData(){
        self.user = nil
    }
    
    
    func emptyUser() -> User{
        return User(id: "", Email: "", Name: "", Preffered: 0, ProfilePicture: 0)
    }
    
    static let shared = UserData()
}

struct User : Identifiable {
    var id: String
    
    var Email : String
    var Name : String
    var Preffered : Int
    var ProfilePicture : Int
}

