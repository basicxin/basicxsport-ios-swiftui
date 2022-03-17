//
//  MyCircleViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 29/01/22.
//

import Combine
import Networking
import SwiftUI

class MyCircleViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var myCircleResponse: MyCircleResponse? = nil
    @Published var preferredCircleResponse: PreferredCircle? = nil

    @Published var alert: AlertDialog?
    @Published var isLoading = false 

    init() {
        getMyCircle()
    }

    func getMyCircle() {
        isLoading = true
        let promise = api.getMyCircle()
        PromiseHandler<BaseResponse<MyCircleResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil {
                    myCircleResponse = response.data!
                    UserDefaults.preferredCircleId = myCircleResponse!.preferredCircle.id!
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func changePreferredCircle(circleId: Int, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.changePreferredCircle(circleId: circleId)
        PromiseHandler<BaseResponse<EmptyData>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
//                    alert = AlertDialog(message: response.message)
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }
}
