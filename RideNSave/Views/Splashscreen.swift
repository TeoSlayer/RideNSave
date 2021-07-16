//
//  Splashscreen.swift
//  RideNSave
//
//  Created by Calin Teodor on 7/15/21.
//

import SwiftUI

struct Splashscreen: View {
    @Binding var Login : Bool
    var body: some View {
        ZStack(alignment: .bottomLeading){
            
            Image("Splashscreen").resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).padding(.top,UIApplication.shared.statusBarFrame.height + 10)
            VStack(alignment: .leading){
                Text("Connecting you with the").font(.title2).foregroundColor(.white)
                Text("people, places, \nand things you love").font(.title).foregroundColor(.accentColor)
                ButtonForward(inverted: false).onTapGesture {
                    self.Login.toggle()
                }.padding(.bottom)
            }.padding().padding(.bottom,50)
        }.ignoresSafeArea()
        
    }
}

struct Splashscreen_Previews: PreviewProvider {
    static var previews: some View {
        Splashscreen(Login: .constant(false))
    }
}
