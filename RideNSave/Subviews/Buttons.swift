//
//  Buttons.swift
//  RideNSave
//
//  Created by Calin Teodor on 15.07.2021.
//

import SwiftUI

struct ButtonForward: View {
    var inverted : Bool
    var body: some View {
        ZStack{
            Circle().foregroundColor(.secondary).frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Image(systemName: "chevron.right").foregroundColor(.accentColor).frame(width: 24, height: 24).foregroundColor(Color(red: 0.0823, green: 0.0823, blue: 0.10, opacity: 1.0)).rotationEffect(Angle(degrees: inverted == true ? 180 : 0))
        }
    }
}

struct ButtonForward_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            ButtonForward(inverted: false)
        })
        
    }
}
