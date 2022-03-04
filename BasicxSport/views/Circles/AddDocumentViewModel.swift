//
//  AddDocumentViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 07/02/22.
//

import Combine
import Foundation
import SwiftUI
import Networking

class AddDocumentViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var circleInfo: CircleInfo?
    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var documentNumber: String = ""
    @Published var searchName: String = ""
    @Published var isFormDataValid = false
    @Published var imageData: Data?
    var docRegex: String = ""
    var documentNumberPrompt: String {
        isFormDataValid ? "" : "Document number is not valid"
    }

    init() {
        Publishers.CombineLatest($documentNumber, $imageData)
            .map { docNumber, data in
                data != nil && NSPredicate(format: "SELF MATCHES %@", self.docRegex).evaluate(with: docNumber)
            }
            .assign(to: \.isFormDataValid, on: self)
            .store(in: &cancellables)
    }

    func uplaodDocument(docTypeId: Int, docName: String, jpegData: Data, completion: @escaping () -> ()) {
        isLoading = true
        let params: [String: CustomStringConvertible] = ["docTypeId": docTypeId, "docNo": documentNumber, "docName": docName]
        let multipartData = MultipartData(name: "file",
                                          fileData: jpegData,
                                          fileName: "photo.jpg",
                                          mimeType: "image/jpeg")

        NetworkSetup().network.post(URLs.DOCUMENT_UPLOAD, params: params, multipartData: multipartData)
            .sink(receiveCompletion: { [self] completion in
                switch completion {
                case .finished:
                    isLoading = false
                case .failure(let error):
                    switch error {
                    default:
                        isLoading = false
                        alert = AlertDialog(message: error.getError())
                    }
                }
            }) { [self] (data: Data?, _: Progress) in

                if data != nil {
                    isLoading = false
                    completion()
                } else {
//                     (progress.fractionCompleted.string)
                }
            }.store(in: &cancellables)
    }
}
