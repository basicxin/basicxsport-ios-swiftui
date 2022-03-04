//
//  GalleryPhotoListView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 01/02/22.
//

import Kingfisher
import SwiftUI

struct GalleryPhotoListView: View {
    var gallery: GalleryBean?
    var body: some View {
        if gallery != nil {
            ZStack {
                List {
                    Text(gallery!.galaryListDescription)
                        .fullWidth(alignement: .leading)
                        .padding(.horizontal, 5)
                        .listRowSeparator(.hidden)
                        .lineLimit(4)

                    ForEach(gallery!.galleryPhotos, id: \.self) { photo in
                        ZStack {
                            VStack {
                                KFImage(URL(string: photo.photoUrl))
                                    .placeholder {
                                        DefaultPlaceholder()
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 180)
                                    .clipped()

                                Text(photo.title)
                                    .font(.subheadline)
                                    .lineLimit(3)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            .withDefaultShadow()

                            NavigationLink(destination: ImageViewerView(url: photo.photoUrl, caption: photo.title)) {
                                EmptyView()
                            }
                            .frame(width: 0)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(gallery!.name)

            }.padding(.top, 1).fullSize()
        }
    }
}

struct GalleryPhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GalleryPhotoListView()
        }
    }
}
