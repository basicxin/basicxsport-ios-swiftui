//
//  RegistrationOTPView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 21/01/22.
//

import Kingfisher
import SwiftUI

struct RegistrationOTPView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var viewModel: RegistrationViewModel

    @State var remainingTime = 60
    @State var isResendOTPDisabled = true

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Image(systemName: "iphone")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.bottom, 30)

            Text("We have sent you an SMS with OTP for the mobile number varification").multilineTextAlignment(.center)
                .padding(.bottom, 30)

            EntryFieldWithValidation(sfSymbolName: "iphone", placeholder: "Ener OTP", prompt: viewModel.otpPrompt, field: $viewModel.otp)

            Button(action: {
                validateOTP()
            }, label: {
                Text("Confirm")
            })
            .disabled(!viewModel.isOTPValid)
            .buttonStyle(.bordered)
            .padding(.bottom, 30)

            Text("You can request for new OTP after \(remainingTime) seconds")
                .font(.footnote)
                .foregroundColor(Color.secondaryLabel)
                .multilineTextAlignment(.center).padding()
                .onReceive(timer) { _ in
                    if remainingTime > 0 {
                        remainingTime -= 1
                    } else {
                        stopTimer()
                        isResendOTPDisabled = false
                    }
                }

            Button {
                isResendOTPDisabled = true
                startTimer()
            } label: {
                Text("Resend")
            }
            .buttonStyle(.bordered).padding(.bottom, 30)
            .disabled(isResendOTPDisabled)
        }

        .padding()
        .onAppear {
            viewModel.sendOTP()
            startTimer()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text("Alert"),
                message: Text(alert.message),
                dismissButton: .default(Text("Ok")) {
                    alert.dismissAction?()
                }
            )
        }
        .environmentObject(viewModel)
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

    func startTimer() {
        remainingTime = 60
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func validateOTP() {
        let newUser = RegisterNewUserRequest(firstName: viewModel.firstName, lastName: viewModel.lastName, title: viewModel.title, gender: viewModel.gender, emailAddress: viewModel.email, password: viewModel.password, mobile: viewModel.mobile, dob: viewModel.dob.getFormattedDate(format: Constants.DateFormats.DOB_DATE_FORMAT_FORMAT_FOR_SERVER), os: "iOS", token: "", deviceType: "iPhone", appVer: "Development Build", apiKey: UserDefaults.jwtKey, sportId: viewModel.selectedSportId!, stateId: viewModel.states[viewModel.selectedStateIndex].id, districtId: viewModel.districts[viewModel.selectedDistrictIndex].id)
        viewModel.validateOTPForSignup(otpCodeId: viewModel.otpObjectId, otp: viewModel.otp, newUser: newUser) {
            saveUserDefault(signUpResponse: viewModel.signUpResponse!)
            settings.loggedIn = true
        }
    }

    func saveUserDefault(signUpResponse: SignUpResponse) {
        UserDefaults.jwtKey = signUpResponse.jwtToken!
        UserDefaults.isLoggedIn = true
        UserDefaults.memberId = signUpResponse.memberId!
        UserDefaults.userFirstName = viewModel.firstName
        UserDefaults.userLastName = viewModel.lastName
        UserDefaults.email = viewModel.email
        UserDefaults.phoneNo = viewModel.mobile
        UserDefaults.profilePictureUrl = signUpResponse.profilePictureUrl!
        UserDefaults.relationshipType = signUpResponse.relationshipType!
        UserDefaults.preferredSportId = viewModel.selectedSportId!
        UserDefaults.preferredSportName = "N/A" // TODO: Get All from server; same as login
        UserDefaults.preferredSportLogoUrl = "N/A"
    }
}

struct RegistrationOTPView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationOTPView()
            .environmentObject(RegistrationViewModel())
    }
}
