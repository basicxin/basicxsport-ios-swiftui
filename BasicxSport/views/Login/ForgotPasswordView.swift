//
//  PasswordView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 19/01/22.
//

import SwiftUI
struct ForgotPasswordView: View {
    @Binding var shouldShowForgetPasswordView: Bool
    @State private var emailId: String = ""
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            MainView(shouldShowForgetPasswordView: $shouldShowForgetPasswordView, viewModel: viewModel)
        }
    }
}

struct MainView: View {
    @Binding var shouldShowForgetPasswordView: Bool
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        VStack {
            Spacer()

            Text("Forgot Passowrd?")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Text("You need to provid your registered email address to get the password reset link")
                .multilineTextAlignment(.center)
                .padding(.vertical, 1)

            Spacer()

            EntryFieldWithValidation(sfSymbolName: "envelope", placeholder: "Email Id", prompt: viewModel.emailPrompt, field: $viewModel.email)

            Spacer()
            Button {
                viewModel.forgetPassword(emailAddress: viewModel.email) {}
            } label: {
                Text("Done")
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isEmailCriteriaValid)

            Spacer()
        }
        .padding()
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text("Alert"),
                message: Text(alert.message),
                dismissButton: .default(Text("Ok")) {
                    alert.dismissAction?()
                    shouldShowForgetPasswordView = false
                }
            )
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(shouldShowForgetPasswordView: .constant(false))
    }
}
