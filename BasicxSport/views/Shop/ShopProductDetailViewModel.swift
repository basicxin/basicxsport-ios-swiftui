//
//  ShopProductDetailViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 25/01/22.
//

import Combine
import Foundation

class ShopProductDetailViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var shopProductDetail: ShopProductDetailMerchandise? = nil
    @Published var isProductInCart = false

    func getShopProductDetail(productId: Int) {
        isLoading = true
        let promise = api.getShopProductDetail(productId: productId)
        PromiseHandler<BaseResponse<ShopProductDetailResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.merchandise != nil {
                        shopProductDetail = response.data!.merchandise
                        isProductInCart = response.data!.merchandise.inCart
                    } else {
                        alert = AlertDialog(message: Constants.NoData)
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
