//
//  ChangePasswordViewModel.swift
//  BasicxSport
//
//  Created by Somesh K on 11/02/22.
//

import Combine

class ChangePasswordViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []

    @Published var alert: AlertDialog?
    @Published var isLoading = false

    @Published var newPassword: String = ""
    @Published var isNewPasswordValid = false
    var newPasswordPromt: String {
        isNewPasswordValid ? "" : "New password must be more than 7 charcters long"
    }

    @Published var confirmPassword: String = ""
    @Published var isConfirmPasswordValid = false
    var confimrPasswordPromt: String {
        isConfirmPasswordValid ? "" : "confirm password must be same as new password"
    }

    @Published var oldPassword: String = ""
    @Published var isOldPasswordValid = false
    var oldPasswordPromt: String {
        isOldPasswordValid ? "" : "Old password must be more than 7 charcters long"
    }

    @Published var canSubmit = false

    init() {
        Publishers.CombineLatest3($isNewPasswordValid, $isConfirmPasswordValid, $isOldPasswordValid)
            .map { isNewPasswordValid, isConfirmPasswordValid, isOldPasswordValid in
                isNewPasswordValid && isConfirmPasswordValid && isOldPasswordValid
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)

        $newPassword
            .map { newPassword in
                newPassword.trimmed.count >= 7
            }
            .assign(to: \.isNewPasswordValid, on: self)
            .store(in: &cancellables)

        $confirmPassword
            .map { oldPassword in
                oldPassword.trimmed.count >= 7 && self.newPassword == oldPassword
            }
            .assign(to: \.isConfirmPasswordValid, on: self)
            .store(in: &cancellables)

        $oldPassword
            .map { newPassword in
                newPassword.trimmed.count >= 7
            }
            .assign(to: \.isOldPasswordValid, on: self)
            .store(in: &cancellables)
    }

    func changePassword(newPassword: String, oldPassword: String, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.changePassword(newPassword: newPassword, oldPassword: oldPassword)
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
}
