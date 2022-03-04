//
//  PrimaryButtonView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 19/01/22.
//

import SwiftUI

struct PrimaryButtonView: View {
    var buttonText: String
    var body: some View {
        Text(buttonText)
            .padding(EdgeInsets(top: 6, leading: 11, bottom: 6, trailing: 11))
            .foregroundColor(.label)
            .background(.tertiary)
            .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)
    }
}

struct PrimaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonView(buttonText: "Button")
            .previewLayout(.sizeThatFits)
    }
}
