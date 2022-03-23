//
//  MyWallViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 22/03/22.
//

import Combine
import Foundation

class MyWallViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var myWallResponse: MyWallResponse? = nil

    @Published var alert: AlertDialog?
    @Published var isLoading = false

    func getMyWall() {
        isLoading = true
        let promise = api.getMyWall()
        PromiseHandler<BaseResponse<MyWallResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil {
                    myWallResponse = response.data!
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }
}
