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
    @Published var memberDocuments: [MemberDocument]? = nil
    @Published var addressList: [Address]? = nil
    @Published var orders: [Order] = .init()
    var cancellables: Set<AnyCancellable> = []

    @Published var isLoadingMore = false
    private var pageNo = 1
    private var isDataFullyLoaded = false

    func getDocuments() {
        isLoading = true
        let promise = api.getDocuments()
        PromiseHandler<BaseResponse<DocumentListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil, !response.data!.memberDocuments.isEmpty {
                    memberDocuments = response.data!.memberDocuments
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

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

    func getAddresses() {
        isLoading = true
        let promise = api.getAddresses()
        PromiseHandler<BaseResponse<AddressListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil, !response.data!.address.isEmpty {
                    addressList = response.data!.address
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func deleteAddresses(objectId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.deleteAddress(objectId: objectId)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func makeDefaultAddress(objectId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.makeDefaultAddress(objectId: objectId)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func getFullAddress(address: Address) -> String {
        let NEW_LINE = "\n"
        let SEPARATOR = ", "
        var addressBuilder = ""

        if !address.streetAddress.isNilOrEmpty {
            addressBuilder.append(address.streetAddress!)
            addressBuilder.append(NEW_LINE)
        }

        if !address.city.isNilOrEmpty {
            addressBuilder.append(address.city!)
            addressBuilder.append(SEPARATOR)
        }
        if address.district != nil {
            addressBuilder.append(address.district!.name)
            addressBuilder.append(NEW_LINE)
        }
        if address.state != nil {
            addressBuilder.append(address.state!.name)
            addressBuilder.append(NEW_LINE)
        }
        if address.country != nil {
            addressBuilder.append(address.country!.name)
            addressBuilder.append(SEPARATOR)
        }
        if !address.postalCode.isNilOrEmpty {
            addressBuilder.append(address.postalCode!)
        }
        if addressBuilder.trim().ends(with: SEPARATOR) {
            addressBuilder = addressBuilder.truncated(toLength: addressBuilder.count - 1)
        }

        return addressBuilder
    }
}
