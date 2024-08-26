//
//  AddDocumentView.swift
//  BasicxSport
//
//  Created by Somesh K on 05/02/22.
//

import Kingfisher
import Networking
import SwiftUI

struct AddDocumentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = AddDocumentViewModel()
    @State private var shouldPresentActionScheet = false

    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false

    @State var searchName: String = ""
    var title = "Document"
    var documentUrl = ""
    var identityType: IdentityType

    init(identityType: IdentityType) {
        self.identityType = identityType
        viewModel.docRegex = identityType.identityIdRule
        viewModel.isViewMode = false
        viewModel.isEditingTheDocument = true
        viewModel.docUrl = nil
        title = "Add Document"
    }

    init(memberDocument: MemberDocument) {
        identityType = memberDocument.docType
        viewModel.searchName = memberDocument.searchName
        viewModel.docRegex = memberDocument.docType.identityIdRule
        viewModel.memberDocid = memberDocument.id
        viewModel.isViewMode = true
        viewModel.isEditingTheDocument = false
        viewModel.documentNumber = memberDocument.docIdentityNo
        viewModel.docUrl = memberDocument.docFileUrl
        documentUrl = memberDocument.docFileUrl
        title = "View document"
    }

    var body: some View {
        Form {
            Section {
                Text("Document Type").font(.subheadline).foregroundColor(.gray)
                Text(identityType.name)
            }

            HStack {
                Text("Document Attachment").font(.subheadline).foregroundColor(.gray)
                Spacer()

                Button {
                    self.shouldPresentActionScheet = true
                } label: {
                    Text("Browse Photo").font(.caption)
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.isEditingTheDocument)
            }

            if viewModel.isViewMode, !viewModel.isEditingTheDocument {
                KFImage(URL(string: documentUrl))
                    .placeholder {
                        DefaultPlaceholder()
                    }
                    .resizable()
                    .scaledToFill()
                    .fullWidth()
                    .frame(height: 150)
                    .clipped()
            } else {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .scaledToFill()
                        .fullWidth()
                        .frame(height: 150)
                        .clipped()
                } else {
                    Image("basicxPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .fullWidth()
                        .frame(height: 150)
                        .clipped()
                }
            }

            Section {
                Text("Document ID").font(.subheadline).foregroundColor(.gray)

                EntryFieldWithValidation(sfSymbolName: "number", placeholder: "Document Number", prompt: viewModel.documentNumberPrompt, field: $viewModel.documentNumber)
                    .keyboardType(identityType.isNumeric ? UIKeyboardType.numberPad : UIKeyboardType.default)
                    .disabled(!viewModel.isEditingTheDocument)
            }

            Section {
                Text("Search name").font(.subheadline).foregroundColor(.gray)
                TextField("Optional", text: $viewModel.searchName)
                    .disabled(!viewModel.isEditingTheDocument)
            }
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                if viewModel.isViewMode, !viewModel.isEditingTheDocument {
                    Button {
                        viewModel.isEditingTheDocument = true
                    } label: {
                        Text("Edit")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isFormDataValid, viewModel.isEditingTheDocument {
                    Button {
                        if viewModel.isViewMode {
                            viewModel.updateDocument(memberdocId: viewModel.memberDocid, docTypeId: identityType.id, docName: viewModel.searchName.isEmpty ? identityType.name : viewModel.searchName, jpegData: self.selectedImage!.jpegData(compressionQuality: 0.1)!) {}
                        } else {
                            viewModel.uplaodDocument(docTypeId: identityType.id, docName: viewModel.searchName.isEmpty ? identityType.name : viewModel.searchName, jpegData: self.selectedImage!.jpegData(compressionQuality: 0.1)!) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text(viewModel.isViewMode ? "Update" : "Add Document")
                    }
                }
            }
        }
        .sheet(isPresented: $isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        .onChange(of: self.selectedImage, perform: { newValue in
            viewModel.imageData = newValue?.jpegData(compressionQuality: 0.1)
        })
        .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddDocumentView(identityType: IdentityType(id: 1, name: "", identityTypeDescription: "", identityIdRule: "", minChar: 1, maxChar: 1, isNumeric: false))
        }
    }
}
