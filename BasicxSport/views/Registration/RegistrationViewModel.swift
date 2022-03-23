//
//  RegistrationViewModel.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 13/01/22.
//

import Combine
import Networking
import SwifterSwift
import SwiftUI

class RegistrationViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    @Published var signUpResponse: SignUpResponse? = nil

    @Published var alert: AlertDialog?
    @Published var isLoading = false

    // Step 1

    @Published var selectedStateIndex: Int = -1
    @Published var selectedDistrictIndex: Int = -1
    @Published var selectedSportId: Int? = nil
    @Published var canSubmitStep1 = false

    @Published var states: [States] = [States(id: -1, name: "Select A State")]
    @Published var districts: [District] = [District(id: -1, name: "Select A District")]
    @Published var sportsList: [SportsListSport] = []

    // Step 2
    @Published var title: String = "Mr."
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dob = Date()
    @Published var gender: String = "Male"

    @Published var isFirstNameValid = false
    @Published var isLastNameValid = false
    @Published var isDOBValid = false
    @Published var canSubmitStep2 = false

    // Step 3
    @Published var email: String = ""
    @Published var mobile: String = ""
    @Published var password: String = ""
    @Published var confirmPassword = ""

    @Published var isEmailValid = false
    @Published var isMobileValid = false
    @Published var isPasswordValid = false
    @Published var isConfirmPasswordValid = false
    @Published var canSubmitStep3 = false

    // Step 4
    @Published var otpObjectId = -1
    @Published var otp: String = ""
    @Published var isOTPValid = false
    @Published var canSubmitStep4 = false
    @Published var isRegistrationSuceessfull = false

    // Step Child Add
    @Published var isAddingChild: Bool = false
    @Published var childRegistrationSuccessful: Bool = false
    
    var firstNamePrompt: String {
        isFirstNameValid ? "" : "First name must not be empty"
    }

    var lastNamePrompt: String {
        isLastNameValid ? "" : "Last name must not be empty"
    }

    var dobPrompt: String {
        isDOBValid ? "" : "Age should be greter than 12"
    }

    var emailPrompt: String {
        isEmailValid ? "" : "Enter valid email"
    }

    var mobilePrompt: String {
        isMobileValid ? "" : "Enter valid mobile number"
    }

    var passwordPrompt: String {
        isPasswordValid ? "" : "Must be at least 8 characters long"
    }

    var confirmPassowrdPrompt: String {
        isConfirmPasswordValid ? "" : "Confirm passowrd should match the password"
    }

    var otpPrompt: String {
        isOTPValid ? "" : "Please enter recieved OTP"
    }

    init() {
        Publishers.CombineLatest3($selectedStateIndex, $selectedDistrictIndex, $selectedSportId)
            .map { selectedStateIndex, selectedDistrictIndex, selectedSportId in
                selectedStateIndex != -1 && selectedDistrictIndex != -1 && selectedSportId != nil
            }
            .assign(to: \.canSubmitStep1, on: self)
            .store(in: &cancellables)

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
            .assign(to: \.canSubmitStep2, on: self)
            .store(in: &cancellables)

        $email
            .map { email in
                Constants.Predicate.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)

        $mobile
            .map { mobile in
                Constants.Predicate.mobilePredicate.evaluate(with: mobile)
            }
            .assign(to: \.isMobileValid, on: self)
            .store(in: &cancellables)

        $password
            .map { password in
                password.trimmed.count >= 7
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest($confirmPassword, $password)
            .map { confirmPassword, password in
                confirmPassword == password
            }
            .assign(to: \.isConfirmPasswordValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest4($isEmailValid, $isMobileValid, $isPasswordValid, $isConfirmPasswordValid)
            .map { isEmailValid, isMobileValid, isPasswordValid, isConfirmPasswordValid in
                isEmailValid && isMobileValid && isPasswordValid && isConfirmPasswordValid
            }
            .assign(to: \.canSubmitStep3, on: self)
            .store(in: &cancellables)

        $otp
            .map { otp in
                otp.trimmed.count >= 1
            }
            .assign(to: \.isOTPValid, on: self)
            .store(in: &cancellables)
    }

    // MARK: APIs

    func getStates() {
        isLoading = true
        let promise = api.getStates()
        PromiseHandler<BaseResponse<StateResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    response.data.run { data in
                        self.states = data.states
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func getDistricts(withStateId stateId: Int) {
        isLoading = true
        let promise = api.getDistricts(withStateId: stateId)
        PromiseHandler<BaseResponse<DistrictResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    response.data.run { data in
                        self.districts = data.districts
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func getSportList() {
        isLoading = true
        let promise = api.getSportList()
        PromiseHandler<BaseResponse<SportsListResponse>>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status {
                    response.data.run { data in
                        self.sportsList = data.sports
                    }
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func sendOTP() {
        isLoading = true
        let promise = api.getOTP(mobile: mobile, apiKey: UserDefaults.jwtKey)
        PromiseHandler<MobileOtpResponse>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    otpObjectId = response.objectId ?? -1
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func validateOTPForSignup(otpCodeId: Int, otp: String, newUser: RegisterNewUserRequest, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.validateOTPForSignup(otpCodeId: otpCodeId, otp: otp, apiKey: UserDefaults.jwtKey)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    registerNewsuser(newUser: newUser, completion: completion)
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func registerNewsuser(newUser: RegisterNewUserRequest, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.signup(newUser)
        PromiseHandler<SignUpResponse>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    signUpResponse = response
                    completion()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }

    func registerNewChild(newUser: RegisterNewChildRequest, completion: @escaping () -> ()) {
        isLoading = true
        let promise = api.addNewChild(newUser)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    childRegistrationSuccessful = true
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
