//
//  AddDocumentViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 07/02/22.
//

import Combine
import Foundation
import Networking
import SwiftUI

class AddDocumentViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var circleInfo: CircleInfo?
    @Published var alert: AlertDialog?
    @Published var isLoading = false
    @Published var documentNumber: String = ""
    @Published var searchName: String = ""
    @Published var docUrl: String? = nil
    @Published var isFormDataValid = false
    @Published var isDocumentNumberValid = false
    @Published var imageData: Data?
    @Published var isViewMode = false
    @Published var isEditingTheDocument = false

    var docRegex: String = ""
    var memberDocid: Int = 0
    var documentNumberPrompt: String {
        isDocumentNumberValid ? "" : "Document number is not valid"
    }

    init() {
        $documentNumber
            .map { docNumber in
                NSPredicate(format: "SELF MATCHES %@", self.docRegex).evaluate(with: docNumber)
            }
            .assign(to: \.isDocumentNumberValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest3($documentNumber, $imageData, $docUrl)
            .map { docNumber, data, docUrl in
                (data != nil || !docUrl.isNilOrEmpty) && NSPredicate(format: "SELF MATCHES %@", self.docRegex).evaluate(with: docNumber)
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

    func updateDocument(memberdocId: Int, docTypeId: Int, docName: String, jpegData: Data, completion: @escaping () -> ()) {
        isLoading = true
        let params: [String: CustomStringConvertible] = ["docTypeId": docTypeId, "docNo": documentNumber, "docName": docName, "memberdocId": memberdocId]
        let multipartData = MultipartData(name: "file",
                                          fileData: jpegData,
                                          fileName: "photo.jpg",
                                          mimeType: "image/jpeg")

        NetworkSetup().network.post(URLs.DOCUMENT_UPDATE, params: params, multipartData: multipartData)
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
