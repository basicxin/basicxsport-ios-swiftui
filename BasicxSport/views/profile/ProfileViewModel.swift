//
//  ProfileViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 12/02/22.
//

import Combine
import Foundation

class ProfileViewModel: ObservableObject {
    private let api = API()
    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var userBadge: UserBadgeResponse? = nil
    @Published var orders: [Order] = .init()
    var cancellables: Set<AnyCancellable> = []

    @Published var isLoadingMore = false
    private var pageNo = 1
    private var isDataFullyLoaded = false

    func getUserBadge() {
        isLoading = true
        let promise = api.getUserBadge()
        PromiseHandler<BaseResponse<UserBadgeResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil {
                    userBadge = response.data
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func getOrderHistory() {
        guard !isLoadingMore else { return }

        if !isDataFullyLoaded {
            if pageNo == 1 {
                isLoading = true
            } else {
                isLoadingMore = true
            }

            let promise = api.getOrderHistory(pageNo: pageNo)
            PromiseHandler<BaseResponse<OrderHistoryResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
                if pageNo == 1 { isLoading = false } else { isLoadingMore = false }
                switch result {
                case .success(let response):
                    if response.status, response.data != nil {
                        pageNo += 1
                        orders += response.data!.orders
                    } else {
                        if pageNo > 1 {
                            isDataFullyLoaded = true
                        } else {
                            alert = AlertDialog(message: response.message)
                        }
                    }
                case .failure(let error):
                    alert = AlertDialog(message: error.getError())
                }
            }
        }
    }
}
