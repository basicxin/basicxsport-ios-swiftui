//
//  ChangePasswordview.swift
//  BasicxSport
//
//  Created by Somesh K on 11/02/22.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel = ChangePasswordViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()
            EntryFieldWithValidation(sfSymbolName: "lock", placeholder: "New Password", prompt: viewModel.newPasswordPromt, field: $viewModel.newPassword, isSecure: true)

            EntryFieldWithValidation(sfSymbolName: "lock", placeholder: "Confrim Password", prompt: viewModel.confimrPasswordPromt, field: $viewModel.confirmPassword, isSecure: true)

            EntryFieldWithValidation(sfSymbolName: "lock", placeholder: "Old Password", prompt: viewModel.oldPasswordPromt, field: $viewModel.oldPassword, isSecure: true)
            Spacer()
            Button {
                viewModel.changePassword(newPassword: viewModel.newPassword, oldPassword: viewModel.oldPassword) {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Change Password")
            }.buttonStyle(.bordered)
                .disabled(!viewModel.canSubmit)
        }
        .padding()
        .fullHeight()
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
        .navigationBarTitle("Change Password")
    }
}

struct ChangePasswordview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePasswordView()
        }
    }
}
