//
//  GalleryListViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 01/02/22.
//

import Combine

class GalleryListViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var galleryList = [GalleryBean]()

    init() {
        getGalleryList()
    }

    func getGalleryList() {
        isLoading = true
        let promise = api.getGalleryList()
        PromiseHandler<BaseResponse<GalleryResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    if response.data?.galleryList != nil {
                        galleryList = response.data!.galleryList
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
