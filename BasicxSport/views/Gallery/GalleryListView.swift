//
//  GalleryListView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 01/02/22.
//

import Kingfisher
import SwiftUI

struct GalleryListView: View {
    @StateObject var viewModel = GalleryListViewModel()
    private var columnGrid: [GridItem] =
        Array(repeating: .init(.flexible(), alignment: .center), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnGrid) {
                ForEach(viewModel.galleryList, id: \.self) { gallery in
                    NavigationLink {
                        GalleryPhotoListView(gallery: gallery)
                    } label: {
                        VStack {
                            KFImage(URL(string: gallery.galleryCoverPhotoUrl))
                                .placeholder { DefaultPlaceholder() }
                                .cancelOnDisappear(true)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 150)
                                .clipped()

                            Text(gallery.name)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .frame(height: 60)
                                .padding(.horizontal, 2)
                        }
                        .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)
                        .withDefaultShadow()
                    }
                }
            }
        }
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text("Alert"),
                message: Text(alert.message),
                dismissButton: .default(Text("Ok")) {
                    alert.dismissAction?()
                }
            )
        } 
        .navigationTitle("Gallery")
    }
}

struct GalleryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GalleryListView()
                .navigationTitle("gallery")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
