//
//  RegistrationStep3View.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 20/01/22.
//

import SwiftUI

struct RegistrationStep3View: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                RegistrationStep3MainView(viewModel: viewModel, settings: settings)
                    .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle("Registration (Step 3)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RegistrationStep3MainView: View {
    @StateObject var viewModel: RegistrationViewModel
    @StateObject var settings: UserSettings
    @State private var shouldMoveToNextView = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Group {
                NavigationLink(destination:
                    RegistrationOTPView()
                        .environmentObject(viewModel)
                        .environmentObject(settings),
                    isActive: $shouldMoveToNextView) {
                        EmptyView()
                    }
            }
            Spacer()

            ZStack(alignment: .trailing) {
                EntryFieldWithValidation(sfSymbolName: "envelope", placeholder: "Email Id", prompt: viewModel.emailPrompt, field: $viewModel.email, onFocus: { isFocused in
                    if viewModel.isEmailValid, !isFocused {
                        viewModel.checkEmailOnServer(emailAddress: viewModel.email, apiKey: UserDefaults.jwtKey)
                    }
                })
                .keyboardType(.emailAddress)

                if viewModel.isCheckingEmailOnServer {
                    ProgressView().progressViewStyle(.circular).padding(.horizontal).padding(.bottom, 10)
                }
            }

            ZStack(alignment: .trailing) {
                EntryFieldWithValidation(sfSymbolName: "iphone", placeholder: "Mobile", prompt: viewModel.mobilePrompt, field: $viewModel.mobile, onFocus: { isFocused in
                    if viewModel.isMobileValid, !isFocused {
                        viewModel.checkMobileOnServer(mobile: viewModel.mobile, apiKey: UserDefaults.jwtKey)
                    }
                })
                .keyboardType(.phonePad)

                if viewModel.isCheckingMobileOnServer {
                    ProgressView().progressViewStyle(.circular).padding(.horizontal).padding(.bottom, 10)
                }
            }

            EntryFieldWithValidation(sfSymbolName: "lock", placeholder: "Password", prompt: viewModel.passwordPrompt, field: $viewModel.password, isSecure: true)

            EntryFieldWithValidation(sfSymbolName: "lock", placeholder: "Confirm Password", prompt: viewModel.confirmPassowrdPrompt, field: $viewModel.confirmPassword, isSecure: true)

            Spacer()

            Button {
                shouldMoveToNextView = true
            } label: {
                Text("Next")
            }
            .disabled(!viewModel.canSubmitStep3)
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct RegistrationStep3View_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegistrationStep3View()
        }
        .environmentObject(RegistrationViewModel())
    }
}
