//
//  NewsView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import Kingfisher
import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        List(viewModel.newsList, id: \.self) { news in
            Link(destination: URL(string: news.publishedNewsURL)!) {
                NewsRow(news: news)
            }
        }
        .listStyle(.plain)
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
    }
}

struct NewsRow: View {
    var news: News
    var body: some View {
        HStack {
            KFImage(URL(string: news.coverPicThumbURL))
                .placeholder {
                    DefaultPlaceholder()
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)

            VStack(alignment: HorizontalAlignment.leading) {
                Text(news.title)
                    .bold()
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)

                Spacer()

                HStack(alignment: VerticalAlignment.bottom) {
                    Label(news.likeCount?.description ?? "0", systemImage: "heart")
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .frame(minWidth: 0, maxWidth: .infinity,
                   minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
