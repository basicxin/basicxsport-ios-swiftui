//
//  CheckoutViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 10/02/22.
//

import Combine
import Foundation

class CheckoutViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var paytmToken: String?

    func getPaytmToken(orderId: String, callbackUrl: String, value: String, currency: String, custId: String) {
        isLoading = true
        let promise = api.getPaytmToken(orderId: orderId, callbackUrl: callbackUrl, value: value, currency: currency, custId: custId)
        PromiseHandler<BaseResponse<PaytmTokenResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data != nil {
                        paytmToken = response.data!.txnToken
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
