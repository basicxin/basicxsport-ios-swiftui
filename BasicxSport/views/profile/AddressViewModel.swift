//
//  AddressViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 11/03/22.
//

import Combine
import Foundation

class AddressViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false

    @Published var addressList: [Address]? = nil

    @Published var addressType: String = "Home"
    @Published var streetAddress: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""

    @Published var selectedState: String = "Select State"
    @Published var selectedDistrict: String = "Select District"
    @Published var selectedStateId: Int = -1
    @Published var selectedDistrictId: Int = -1

    @Published var states: [Country] = []
    @Published var districts: [Country] = []

    @Published var canSubmitStep = false

    init() {
        Publishers.CombineLatest($selectedStateId, $selectedDistrictId)
            .map { selectedStateIndex, selectedDistrictIndex in
                selectedStateIndex != -1 && selectedDistrictIndex != -1
            }
            .assign(to: \.canSubmitStep, on: self)
            .store(in: &cancellables)
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

    func getStates(completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.getStates()
        PromiseHandler<BaseResponse<StateResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    response.data.run { data in
                        self.states = data.states
                        completion()
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func getDistricts(withStateId stateId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.getDistricts(withStateId: stateId)
        PromiseHandler<BaseResponse<DistrictResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    response.data.run { data in
                        self.districts = data.districts
                        completion()
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func addAddress(countryId: String, stateId: Int, districtId: Int, city: String, postalCode: String, streetAddress: String, addressType: String, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.addAddress(memberId: UserDefaults.memberId, apiKey: UserDefaults.jwtKey, countryId: countryId, stateId: stateId, districtId: districtId, city: city, postalCode: postalCode, streetAddress: streetAddress, addressType: addressType)
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

    func updateAddress(countryId: String, stateId: Int, districtId: Int, city: String, postalCode: String, streetAddress: String, addressType: String, addressId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.updateAddress(memberId: UserDefaults.memberId, apiKey: UserDefaults.jwtKey, countryId: countryId, stateId: stateId, districtId: districtId, city: city, postalCode: postalCode, streetAddress: streetAddress, addressType: addressType, addressId: addressId)
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
