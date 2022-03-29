//
//  NewsView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import ACarousel
import Kingfisher
import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @StateObject var refresh = Events.shared
    var body: some View {
        VStack {
            if !viewModel.newsList.isEmpty {
                List {
                    if !viewModel.bannerList.isEmpty {
                        ACarousel(viewModel.bannerList, id: \.self, spacing: 15, headspace: 15, sidesScaling: 0.7, isWrap: false, autoScroll: .active(8)) { banner in
                            KFImage(URL(string: banner.bannerURL))
                                .placeholder {
                                    DefaultPlaceholder()
                                }
                                .resizable()
                                .frame(height: 150)
                                .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)
                        }
                        .listRowInsets(EdgeInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0)))
                        .frame(height: 150)
                    }

                    ForEach(viewModel.newsList, id: \.self) { news in
                        Link(destination: URL(string: news.publishedNewsURL)!) {
                            NewsRow(news: news)
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                Text(Constants.NoData)
            }
        }
        .fullSize()

        .onReceive(refresh.$myCircleChanged, perform: { isCircleChanged in
            if isCircleChanged {
                viewModel.getNews(isNew: true, time: 0)
            }
        })
        .onReceive(refresh.$newCirclePurchased, perform: { newCirclePurchased in
            if newCirclePurchased {
                viewModel.getNews(isNew: true, time: 0)
            }
        })
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
