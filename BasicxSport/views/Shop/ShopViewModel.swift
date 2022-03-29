//
//  ShopViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 25/01/22.
//

import Combine
import Foundation

class ShopViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var shopProductList = [Merchandise]()
    @Published var cartItemCount = 0

    init() {
        getShopProducts()
    }

    func getShopProducts() {
        isLoading = true
        let promise = api.getShopProduct()
        PromiseHandler<BaseResponse<ShopResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil {
                    if !response.data!.merchandise.isEmpty {
                        shopProductList = response.data!.merchandise
                        cartItemCount = response.data!.cartCount
                    } else {
                        shopProductList = []
                        cartItemCount = 0
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
