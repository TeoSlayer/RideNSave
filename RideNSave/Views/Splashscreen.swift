//
//  Splashscreen.swift
//  RideNSave
//
//  Created by Calin Teodor on 7/15/21.
//

import SwiftUI

struct Splashscreen: View {
    var body: some View {
        Image("Splashscreen").resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct Splashscreen_Previews: PreviewProvider {
    static var previews: some View {
        Splashscreen()
    }
}
