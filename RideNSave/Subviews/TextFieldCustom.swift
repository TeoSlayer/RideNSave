//
//  TextFieldCustom.swift
//  RideNSave
//
//  Created by Calin Teodor on 15.07.2021.
//

import SwiftUI

struct TextFieldCustom: View {
    @Binding var text : String
    var placeholder : String
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.secondary)
            TextField("", text: $text).foregroundColor(.accentColor)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder).foregroundColor(.accentColor)
                }.padding(.horizontal)
        }.cornerRadius(16)
    }
}

struct TextFieldCustom_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCustom(text: .constant(""), placeholder: "enter text")
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
