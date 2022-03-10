//
//  RegistrationStep2View.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 20/01/22.
//

import CryptoKit
import SwiftUI

struct RegistrationStep2View: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                RegistrationStep2MainView(viewModel: viewModel, settings: settings)
                    .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle("Registration (Step 2)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RegistrationStep2MainView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    @StateObject var settings: UserSettings
    @State var shouldMoveToNextView = false

    var titleList: [String] = ["Mr.", "Mrs.", "Miss", "Master"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                NavigationLink(
                    destination: RegistrationStep3View()
                        .environmentObject(viewModel)
                        .environmentObject(settings), isActive: $shouldMoveToNextView) { EmptyView() }
            }

            Group {
                Text("Title")
                Picker("Title", selection: $viewModel.title) {
                    ForEach(titleList, id: \.self) { title in
                        Text(title)
                    }
                }
                .onChange(of: viewModel.title) { newTitle in
                    
                }

                Divider()
                    .padding(.bottom, 30)

                EntryFieldWithValidation(sfSymbolName: "person", placeholder: "First Name", prompt: viewModel.firstNamePrompt, field: $viewModel.firstName).keyboardType(.alphabet)

                EntryFieldWithValidation(sfSymbolName: "person", placeholder: "Last Name", prompt: viewModel.lastNamePrompt, field: $viewModel.lastName).keyboardType(.alphabet)

                Divider()
                    .padding(.bottom, 30)
            }

            Group {
                DatePicker(selection: $viewModel.dob, in: ...Date(), displayedComponents: .date) {
                    Text("Date of Birth")
                }

                Text(viewModel.dobPrompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption).padding(.bottom, 20)

                Text("Gender")
                Picker(selection: $viewModel.gender, label: Text("Gender:")) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }.pickerStyle(.segmented)
            }

            Spacer()

            Button {
                shouldMoveToNextView = true
            } label: {
                Text("Next")
            }.buttonStyle(.bordered)
                .disabled(!viewModel.canSubmitStep2)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct RegistrationStep2View_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegistrationStep2View()
        }
        .environmentObject(RegistrationViewModel())
    }
}
