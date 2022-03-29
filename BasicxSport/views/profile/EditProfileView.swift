//
//  EditProfileView.swift
//  BasicxSport
//
//  Created by Somesh K on 08/03/22.
//

import Kingfisher
import SwiftUI

struct EditProfileView: View {
    var titleList: [String] = ["Mr.", "Mrs.", "Miss", "Master"]

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = EditProfileviewModel()

    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false

    @State private var shouldPresentActionSheet = false

    var body: some View {
        ZStack {
            if viewModel.memberProfile != nil {
                let member = viewModel.memberProfile!.member
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        ZStack {
                            if !viewModel.imageData.isNilOrEmpty {
                                if selectedImage != nil {
                                    Image(uiImage: selectedImage!)
                                        .resizable()
                                        .clipShape(SwiftUI.Circle())
                                        .clipped()
                                        .frame(width: 100, height: 100)
                                } else {
                                    Image("basicxPlaceholder")
                                        .resizable()
                                        .clipShape(SwiftUI.Circle())
                                        .clipped()
                                        .frame(width: 100, height: 100)
                                }

                            } else {
                                KFImage(URL(string: member.profilePictureUrl))
                                    .placeholder {
                                        DefaultPlaceholder()
                                    }
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(SwiftUI.Circle())
                            }

                            Image(systemName: "pencil.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .background(.background)
                                .clipShape(SwiftUI.Circle())
                                .clipped()
                                .offset(x: 35, y: 35)
                                .opacity(0.5)
                                .onTapGesture {
                                    self.shouldPresentActionSheet = true
                                }
                        }
                        .fullWidth()
                        .padding(.bottom, 10)

                        Text("Title")

                        Picker("Title", selection: $viewModel.title) {
                            ForEach(titleList, id: \.self) { title in
                                Text(title)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 20)
                    }

                    Group {
                        EntryFieldWithValidation(sfSymbolName: "person", placeholder: "First Name", prompt: viewModel.firstNamePrompt, field: $viewModel.firstName).keyboardType(.alphabet)
                            .padding(.bottom, 10)

                        EntryFieldWithValidation(sfSymbolName: "person", placeholder: "Last Name", prompt: viewModel.lastNamePrompt, field: $viewModel.lastName).keyboardType(.alphabet)
                            .padding(.bottom, 20)
                    }

                    Group {
                        DatePicker(selection: $viewModel.dob, in: ...Date(), displayedComponents: .date) {
                            Text("Date of Birth")
                        }

                        Text(viewModel.dobPrompt)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption).padding(.bottom, 10)

                        Text("Gender")
                        Picker(selection: $viewModel.gender, label: Text("Gender:")) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }.pickerStyle(.segmented)
                    }
                }
            } else {
                EmptyView()
            }
        }
        .fullSize(alignement: .top).padding()
        .sheet(isPresented: $isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        .onChange(of: self.selectedImage, perform: { newValue in
            viewModel.imageData = newValue?.jpegData(compressionQuality: 0.1)
        })
        .actionSheet(isPresented: $shouldPresentActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }), ActionSheet.Button.cancel()])
        }
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if viewModel.imageData != nil {
                        viewModel.uploadProfilePicture(objectId: UserDefaults.memberId, objectName: "ProfilePicture", jpegData: self.selectedImage!.jpegData(compressionQuality: 0.1)!) {
                            viewModel.updateMemberProfile {
                                dismiss()
                            }
                        }
                    } else {
                        viewModel.updateMemberProfile {}
                    }
                } label: {
                    Text("Update")
                }.disabled(!viewModel.canSubmit)
            }
        }
        .onAppear {
            viewModel.getMemberProfile()
        }
        .navigationTitle("Edit Profile")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
