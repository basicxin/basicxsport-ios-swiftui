//
//  ImageViewerView.swift
//  BasicxSport
//
//  Created by Somesh K on 02/02/22.
//

import Kingfisher
import SwiftUI
struct ImageViewerView: View {
    @State private var scale: CGFloat = 1

    var url: String?
    var caption: String = ""
    var body: some View {
        ZStack {
            KFImage(URL(string: url))
                .placeholder {
                    DefaultPlaceholder()
                }
                .resizable()
                .scaledToFit()
                .zoomable(scale: $scale)
        }
        .fullSize()
        .ignoresSafeArea()
        .navigationTitle(caption)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageViewerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageViewerView()
        }
    }
}
