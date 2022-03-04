//
//  ApplyCouponCodeViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 28/02/22.
//

import Combine
import Foundation

class ApplyCouponCodeViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var couponList: [Coupon]? = nil

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var isEnteredCouponCodeValid = false

    @Published var couponCode: String = ""

    init() {
        $couponCode
            .map { couponCode in
                !couponCode.isEmpty
            }
            .assign(to: \.isEnteredCouponCodeValid, on: self)
            .store(in: &cancellables)
    }

    func getCoupon() {
        isLoading = true
        let promise = api.getPromoCodes()
        PromiseHandler<BaseResponse<PromoCodesResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data != nil, !response.data!.coupons.isEmpty {
                        couponList = response.data!.coupons
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

    func applyCoupon(apiKey: String, memberId: Int, couponCode: String, salesId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.applyCoupon(apiKey: apiKey, memberId: memberId, couponCode: couponCode, salesId: salesId)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }
}
