//
//  TournamentViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 14/03/22.
//

import Combine
import Foundation

class TournamentViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false

    @Published var tournamentList = [Tournament]()
    @Published var tournamentCategoryList = [TournamentCategory]()

   
    func getTournaments(circleId: Int) {
        isLoading = true
        let promise = api.getTournaments(circleId: circleId)
        PromiseHandler<BaseResponse<TournamentListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.tournaments.isEmpty == false {
                        tournamentList = response.data!.tournaments
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

    func getTournamentCategories(tournamentId: Int) {
        isLoading = true
        let promise = api.getTournamentCategories(tournamentId: tournamentId)
        PromiseHandler<BaseResponse<TournamentCategoryListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.categories.isEmpty == false {
                        tournamentCategoryList = response.data!.categories
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

    func isCategoryNotOpen(category: TournamentCategory) -> Bool {
        (category.status.caseInsensitiveCompare(Constants.Tournament.CATEGORY_STATUS_IN_PLAY) == .orderedSame) || (category.status.caseInsensitiveCompare(Constants.Tournament.CATEGORY_STATUS_COMPLETED) == .orderedSame) || (category.status.caseInsensitiveCompare(Constants.Tournament.CATEGORY_STATUS_CLOSED) == .orderedSame)
    }
}
