//
//  CircleInfoViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 03/02/22.
//

import Combine
import Foundation

class CircleInfoViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var circleInfo: CircleInfo?
    @Published var alert: AlertDialog?
    @Published var isLoading = false

    func getCirclesInfo(circleId: Int) {
        isLoading = true
        let promise = api.getCirclesInfo(circleId: circleId)
        PromiseHandler<BaseResponse<CircleInfoResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data?.circle != nil {
                    circleInfo = response.data!.circle
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }
}
