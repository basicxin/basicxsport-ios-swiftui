//
//  NewsViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 18/01/22.
//

import Combine
import Foundation
import Networking

class NewsViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var newsList = [News]()
    @Published var bannerList = [Banner]()

    init() {
        getNews(isNew: true, time: 0)
    }

    func getNews(isNew: Bool, time: Int64) {
        isLoading = true
        let promise = API().getNews(isNew: isNew, time: time)
        PromiseHandler<BaseResponse<NewsResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.data != nil, response.status {
                    
                    if !response.data!.news.isEmpty {
                        newsList = response.data!.news
                    } else {
                        newsList = []
                    }

                    if !response.data!.banners.isEmpty {
                        bannerList = response.data!.banners
                    } else {
                        bannerList = []
                    }

                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }
}
