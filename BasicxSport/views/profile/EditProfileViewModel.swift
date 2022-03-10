//
//  EditProfileViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 08/03/22.
//

import Combine
import Foundation
import Networking

class EditProfileviewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var memberProfile: MemberProfileResponse?
    @Published var alert: AlertDialog?
    @Published var isLoading = false

    @Published var title: String = "Mr."
    @Published var firstName: String = UserDefaults.userFirstName
    @Published var lastName: String = UserDefaults.userLastName
    @Published var dob = Date()
    @Published var gender: String = "Male"
    @Published var imageData: Data?

    @Published var isFirstNameValid = false
    @Published var isLastNameValid = false
    @Published var isDOBValid = false
    @Published var canSubmit = false

    var firstNamePrompt: String {
        isFirstNameValid ? "" : "First name must not be empty"
    }

    var lastNamePrompt: String {
        isLastNameValid ? "" : "Last name must not be empty"
    }

    var dobPrompt: String {
        isDOBValid ? "" : "Age should be greter than 12"
    }

    init() {
        $firstName
            .map { firstName in
                !firstName.trimmed.isEmpty
            }
            .assign(to: \.isFirstNameValid, on: self)
            .store(in: &cancellables)

        $lastName
            .map { lastName in
                !lastName.trimmed.isEmpty
            }
            .assign(to: \.isLastNameValid, on: self)
            .store(in: &cancellables)

        $dob
            .map { birthday in
                Calendar.current.dateComponents([.year], from: birthday, to: Date()).year! >= 12
            }
            .assign(to: \.isDOBValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest3($isFirstNameValid, $isLastNameValid, $isDOBValid)
            .map { isFirstNameValid, isLastNameValid, isDOBValid in
                isFirstNameValid && isLastNameValid && isDOBValid
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func getMemberProfile() {
        isLoading = true
        let promise = api.getMemberProfile()
        PromiseHandler<BaseResponse<MemberProfileResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status, response.data != nil {
                    memberProfile = response.data
                    if memberProfile != nil {
                        title = memberProfile!.member.title
                        firstName = memberProfile!.member.firstName
                        lastName = memberProfile!.member.lastName
                        dob = memberProfile!.member.dob.toDate(withFormat: Constants.DateFormats.DOB_DATE_FORMAT)!
                        gender = memberProfile!.member.gender
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func updateMemberProfile(completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.updateMemberProfile(firstName: firstName, lastName: lastName, title: title, gender: gender, dob: dob.getFormattedDate(format: Constants.DateFormats.DOB_DATE_FORMAT_FORMAT_FOR_SERVER))
        PromiseHandler<BaseResponse<EmptyData>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func uploadProfilePicture(objectId: Int, objectName: String, jpegData: Data, completion: @escaping () -> ()) {
        isLoading = true
        let params: [String: CustomStringConvertible] = ["object_name": objectName, "object_id": objectId]
        let multipartData = MultipartData(name: "file",
                                          fileData: jpegData,
                                          fileName: "photo.jpg",
                                          mimeType: "image/jpeg")

        NetworkSetup().network.post(URLs.UPLOAD_PROFILE_PICTURE, params: params, multipartData: multipartData)
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
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        if json != nil {
                            if let data = json!["data"] as? [String: Any] {
                                if let pictureUrl = data["profilePictureUrl"] as? String {
                                    UserDefaults.profilePictureUrl = pictureUrl
                                }
                                completion()
                            }
                        }
                    } catch {
                        alert = AlertDialog(message: "Json encoding error")
                    }

                } else {
//                     (progress.fractionCompleted.string)
                }
            }.store(in: &cancellables)
    }
}
