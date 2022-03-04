//
//  EntryFieldWithValidation.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 21/01/22.
//

import SwiftUI

struct EntryFieldWithValidation: View {
    var sfSymbolName: String
    var placeholder: String
    var prompt: String
    @Binding var field: String
    var isSecure = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: sfSymbolName)
                    .foregroundColor(.gray)
                    .font(.headline)
                    .frame(width: 20)
                if isSecure {
                    SecureField(placeholder, text: $field)
                } else {
                    TextField(placeholder, text: $field)
                }
            }.autocapitalization(.none)
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .overlay(RoundedRectangle(cornerRadius: Constants.Size.DEFAULT_CORNER_RADIUS).stroke(Color.gray, lineWidth: 1))
            Text(prompt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
    }
}

struct EntryFieldWithValidation_Previews: PreviewProvider {
    static var previews: some View {
        EntryFieldWithValidation(sfSymbolName: "iphone", placeholder: "Enter Mobile Number", prompt: "Please enter valid mobile number", field: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
