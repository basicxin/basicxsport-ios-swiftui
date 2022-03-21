//
//  MyMatchesViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 17/03/22.
//

import Combine
import Foundation

class MyMatchesViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false

    @Published var upcomingMatches = [Match]()
    @Published var inPlayMatches = [Match]()
    @Published var completedMatches = [Match]()

 
    func getMyMatches(matchType: String) {
        isLoading = true
        let promise = api.getMyMatches(matchType: matchType)
        PromiseHandler<BaseResponse<MyMatchesListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.matches.isEmpty == false {
                        if matchType == Constants.Matches.MATCH_STATUS_OPEN {
                            upcomingMatches = response.data!.matches
                        } else if matchType == Constants.Matches.MATCH_STATUS_COMPLETED {
                            completedMatches = response.data!.matches
                        } else if matchType == Constants.Matches.MATCH_STATUS_IN_PLAY {
                            inPlayMatches = response.data!.matches
                        }
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
