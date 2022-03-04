//
//  ContentViewModel.swift
//  NetworkingDemo
//
//  Created by Alex Nagy on 02.10.2021.
//

import Combine
import Networking
import SwiftUI

class LoginViewModel: ObservableObject { 
    private let api = API()
    @Published var loginResponse: SignInResponse? = nil

    @Published var alert: AlertDialog?
    @Published var isLoading = false
    var cancellables: Set<AnyCancellable> = []

    @Published var email = ""
    @Published var password = ""

    @Published var isEmailCriteriaValid = false
    @Published var isPasswordCriteriaValid = false
    @Published var canSubmit = false

    var emailPrompt: String {
        isEmailCriteriaValid ? "" : "Enter a valid email address"
    }

    var passwordPrompt: String {
        isPasswordCriteriaValid ? "" : "Must be at least 8 characters long."
    }

    init() {
        $email
            .map { email in
                Constants.Predicate.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isEmailCriteriaValid, on: self)
            .store(in: &cancellables)

        $password
            .map { password in
                password.count >= 8
            }
            .assign(to: \.isPasswordCriteriaValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest($isEmailCriteriaValid, $isPasswordCriteriaValid)
            .map { isEmailCriteriaValid, isPasswordCriteriaValid in
                isEmailCriteriaValid && isPasswordCriteriaValid
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func login(request: SignInRequest, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.login(request)
        PromiseHandler<BaseResponse<SignInResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    self.loginResponse = response.data
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func forgetPassword(emailAddress: String, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.forgetPassword(emailAddress: emailAddress, apiKey: UserDefaults.jwtKey)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    alert = AlertDialog(message: response.message)
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }
}
