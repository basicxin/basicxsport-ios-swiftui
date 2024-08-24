//
//  DeleteAccountViewModel.swift
//  BasicxSport
//
//  Created by BASICX Admin on 17/08/24.
//

import Combine
import Foundation

class DeleteAccountViewModel: ObservableObject {
    private let api = API()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var alert: AlertDialog?
    @Published var isLoading = false
    var onLogout: (() -> Void)?
    
    @Published var mobile: String = ""
    @Published var otpObjectId = -1
    @Published var otp: String = ""
    @Published var isOTPValid = false
    @Published var isMobileValid = false
    @Published var isOTPSent = false
    
    var mobileError = "Enter valid mobile number"
    var mobilePrompt: String {
        isMobileValid ? "" : mobileError
    }
    var otpPrompt: String {
        isOTPValid ? "" : "Please enter recieved OTP"
    }
    
    init() {
        $mobile
            .map { mobile in
                Constants.Predicate.mobilePredicate.evaluate(with: mobile)
            }
            .assign(to: \.isMobileValid, on: self)
            .store(in: &cancellables)
        
        $otp
            .map { otp in
                otp.trimmed.count >= 1
            }
            .assign(to: \.isOTPValid, on: self)
            .store(in: &cancellables)
    }
    
    func sendOTPForAccountDelete() {
        isLoading = true
        let promise = api.deleteAccountOTPRequest(mobile: mobile, apiKey: UserDefaults.jwtKey)
        PromiseHandler<MobileOtpResponse>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    otpObjectId = response.objectId ?? -1
                    isOTPSent = true
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }
    
    func deleteAccount(otp: String, objectId: Int) {
        isLoading = true
        let promise = api.deleteAccount(memberId: UserDefaults.memberId, otp: otp, objectId: objectId, apiKey: UserDefaults.jwtKey)
        PromiseHandler<DefaultResponseAIM>.fulfill(promise, storedIn: &cancellables) { [self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.status == 1 {
                    self.onLogout?()
                } else {
                    alert = AlertDialog(message: response.message)
                }
            case .failure(let error):
                alert = AlertDialog(message: error.getError())
            }
        }
    }
}
