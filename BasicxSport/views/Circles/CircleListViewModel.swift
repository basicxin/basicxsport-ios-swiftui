//
//  CircleListViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 18/01/22.
//

import Combine
import Foundation
import SwiftUI

class CircleListViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var circles: [SearchedCircles] = []
    @Published var sports: [SportsListSport] = []
    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var succesfullyUpdatedPreferedSport = false

    init() {
        getCircles(name: "")
        getPreferedSport()
    }

    func getCircles(name: String) {
        isLoading = true
        let promise = api.getCircles(name: name)
        PromiseHandler<BaseResponse<SearchCircleResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.circles.isEmpty == false {
                        circles = response.data!.circles
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

    func getPreferedSport() {
        isLoading = true
        let promise = api.getPreferedSport()
        PromiseHandler<BaseResponse<SportsListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.sports.isEmpty == false {
                        sports = response.data!.sports
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

    func updatePreferedSport(sportId: Int) {
        isLoading = true
        let promise = api.updatePreferedSport(sportId: sportId)
        PromiseHandler<BaseResponse<EmptyData>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    succesfullyUpdatedPreferedSport = true
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let failure):
                alert = AlertDialog(message: failure.getError())
            }
        }
    }
}
