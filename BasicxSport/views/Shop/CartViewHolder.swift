//
//  CartViewHolder.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 27/01/22.
//
import Combine
import Foundation

class CartViewHolder: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var cart: Cart? = nil
    @Published var goBack: Bool = false
    @Published var isProductInCart = false
    var redirectionTo: String = Constants.VIEW_TO_SHOW_MY_CIRCLE

    func addToCart(objectId: Int, itemType: String, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.addToCart(apiKey: UserDefaults.jwtKey, memberId: UserDefaults.memberId, objectId: objectId, itemType: itemType)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    isProductInCart = true
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }

    func getCart(cartType: String) {
        isLoading = true
        let promise = api.getCart(cartType: cartType)
        PromiseHandler<BaseResponse<CartResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data?.cart != nil {
                    cart = response.data!.cart
                    switch cartType {
                    case Constants.ITEM_TYPE_MERCHANDISE: redirectionTo = Constants.VIEW_TO_SHOW_SHOP
                    case Constants.ITEM_TYPE_SUBSCRIPTION: redirectionTo = Constants.VIEW_TO_SHOW_SUBSCRIPTION
                    case Constants.ITEM_TYPE_WELLNESS_SUBSCRIPTION: redirectionTo = Constants.VIEW_TO_SHOW_SUBSCRIPTION
                    case Constants.ITEM_TYPE_TOURNAMENT: redirectionTo = Constants.VIEW_TO_SHOW_CATEGORY
                    case Constants.ITEM_TYPE_BATCH_MEMBERSHIP: redirectionTo = Constants.VIEW_TO_SHOW_BATCHES
                    default: redirectionTo = Constants.VIEW_TO_SHOW_MY_CIRCLE
                    }

                    if cart!.items.isEmpty {
                        goBack = true
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }

    func changeCartItemQuantity(lineItemId: Int, qty: Int, cartType: String) {
        isLoading = true
        let promise = api.changeCartItemQuantity(apiKey: UserDefaults.jwtKey, memberId: UserDefaults.memberId, lineItemId: lineItemId, qty: qty)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    getCart(cartType: cartType)
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }

    func removeItemFromCart(lineItemId: Int, objectId: Int, cartType: String) {
        isLoading = true
        let promise = api.removeItemFromCart(apiKey: UserDefaults.jwtKey, memberId: UserDefaults.memberId, lineItemId: lineItemId, objectId: objectId)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    getCart(cartType: cartType)
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }

    func clearCouponCode(objectId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.clearCouponCode(apiKey: UserDefaults.jwtKey, memberId: UserDefaults.memberId, objectId: objectId)
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
