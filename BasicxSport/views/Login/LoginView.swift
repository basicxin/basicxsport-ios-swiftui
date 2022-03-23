//
//  LoginView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 11/01/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var settings: UserSettings
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var goToRegistration = false 
    @State private var shouldShowForgetPasswordView = false
    @State private var shouldShowRegistrationView = false

    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            Group {
                NavigationLink(destination: RegistrationStep1View(), isActive: $shouldShowRegistrationView) { EmptyView() }
            }

            LogoView()
            InputFieldsView(emailId: $viewModel.email, password: $viewModel.password, emailPrompt: viewModel.emailPrompt, passwordPrompt: viewModel.passwordPrompt)

            Spacer()

            Button {
                loginUser()
            } label: {
                Text("Sign In")
            }
            .disabled(!viewModel.canSubmit)
            .buttonStyle(.bordered)

            Button("Forgot Password?") {
                shouldShowForgetPasswordView = true
            }
            .foregroundColor(Color.blue)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: Alignment.leading)
            .padding(Edge.Set.vertical, 20)

            Spacer()

            Button {
                shouldShowRegistrationView = true
            } label: {
                Text("Sign Up")
            }
            .buttonStyle(.bordered)

            Spacer()

            Text("By downloading, installing, and using this App, you agree to the following Terms of Service and Privacy Policy")
                .font(.footnote)
        }
        .sheet(isPresented: $shouldShowForgetPasswordView, content: {
            ForgotPasswordView(shouldShowForgetPasswordView: $shouldShowForgetPasswordView)
        })
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.top)
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { currentAlert in
            Alert(
                title: Text("Alert"),
                message: Text(currentAlert.message),
                dismissButton: .default(Text("Ok")) {
                    currentAlert.dismissAction?()
                }
            )
        }
        .navigationBarHidden(true)
    }

    func loginUser() {
        let signInRequest = SignInRequest(appVer: "Developement Build", deviceType: Constants.Device.OS, emailAddress: viewModel.email, fcmToken: "", os: Constants.Device.OS, password: viewModel.password)

        viewModel.login(request: signInRequest) {
            saveUserDefault(signInResponse: viewModel.loginResponse!)
            settings.loggedIn = true
        }
    }
}

// MARK: Login View

struct LogoView: View {
    var body: some View {
        Image("basicxLogo")
            .resizable()
            .aspectRatio(contentMode: ContentMode.fit)
            .frame(width: 200, height: 120, alignment: Alignment.center)
            .padding()
    }
}

struct InputFieldsView: View {
    @Binding var emailId: String
    @Binding var password: String
    var emailPrompt: String
    var passwordPrompt: String

    var body: some View {
        VStack(spacing: 10) {
            EntryFieldWithValidation(sfSymbolName: "envelope", placeholder: "Email Id", prompt: emailPrompt, field: $emailId).keyboardType(.emailAddress)

            EntryFieldWithValidation(sfSymbolName: "lock", placeholder: "Password", prompt: passwordPrompt, field: $password, isSecure: true)
        }
    }
}

func saveUserDefault(signInResponse: SignInResponse) {
    UserDefaults.jwtKey = signInResponse.jwtToken
    UserDefaults.isLoggedIn = true
    UserDefaults.memberId = signInResponse.member.id
    UserDefaults.userFirstName = signInResponse.member.firstName
    UserDefaults.userLastName = signInResponse.member.lastName
    UserDefaults.email = signInResponse.member.emailAddress
    UserDefaults.phoneNo = signInResponse.member.mobile
    UserDefaults.profilePictureUrl = signInResponse.member.profilePictureURL
    UserDefaults.relationshipType = signInResponse.member.relationshipType
    UserDefaults.preferredSportId = signInResponse.member.sport.id
    UserDefaults.preferredSportName = signInResponse.member.sport.name
    UserDefaults.preferredSportLogoUrl = signInResponse.member.sport.sportIconURL
}

// MARK: Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView().environmentObject(UserSettings())
                .navigationBarHidden(true)
        }
    }
}
