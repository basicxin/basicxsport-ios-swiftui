//
//  DeleteAccountView.swift
//  BasicxSport
//
//  Created by BASICX Admin on 17/08/24.
//


import SwiftUI

struct DeleteAccountView: View {
    @StateObject var viewModel = DeleteAccountViewModel()
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("We're sorry to see you go! Please enter your mobile number to securely verify and delete your account.")
                .font(.caption2)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            
            ZStack(alignment: .trailing) {
                EntryFieldWithValidation(
                    sfSymbolName: "iphone",
                    placeholder: "Mobile",
                    prompt: viewModel.mobilePrompt,
                    field: $viewModel.mobile
                )
                .keyboardType(.phonePad)
            }
            
            if(viewModel.isOTPSent) {
                Text("An SMS with an OTP to delete your account has been sent to you")
                    .font(.caption)
                    .padding(.vertical, 20)
                    .multilineTextAlignment(.center)
                
                EntryFieldWithValidation(sfSymbolName: "iphone", placeholder: "Ener OTP", prompt: viewModel.otpPrompt, field: $viewModel.otp)
            }
            
            
            Spacer()
            Spacer()
            
            Button {
                if (viewModel.isOTPSent) {
                    viewModel.deleteAccount(otp: viewModel.otp, objectId: viewModel.otpObjectId)
                } else  {
                    viewModel.sendOTPForAccountDelete()
                }
            } label: {
                Text(viewModel.isOTPSent ? "Delete Account": "Send OTP")
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isOTPSent ? !viewModel.isOTPValid : !viewModel.isMobileValid)
            
            Spacer()
            
        }
        .onAppear {
            viewModel.onLogout = { logout() }
        }
        .padding()
        .fullHeight()
        .customProgressDialog(
            isShowing: $viewModel.isLoading,
            progressContent: {
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
        .navigationBarTitle( "Delelte Account")
    }
    
    func logout() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        settings.loggedIn = false
    }
}

struct DeletePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeleteAccountView()
        }
    }
}
