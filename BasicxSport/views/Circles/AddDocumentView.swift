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
    @State private var image: Image? = Image("basicxPlaceholder")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State var searchName: String = ""
    var title = "Document"
    var documentUrl = ""
    var identityType: IdentityType

    init(identityType: IdentityType) {
        self.identityType = identityType
        viewModel.docRegex = identityType.identityIdRule
        viewModel.isViewMode = false
        viewModel.docUrl = nil
        title = "Add Document"
    }

    init(memberDocument: MemberDocument) {
        identityType = memberDocument.docType
        viewModel.searchName = memberDocument.searchName
        viewModel.docRegex = memberDocument.docType.identityIdRule
        viewModel.isViewMode = true
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

                Button { self.shouldPresentActionScheet = true
                } label: {
                    Text("Browse Photo").font(.caption)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isViewMode)
            }

            if viewModel.isViewMode {
                KFImage(URL(string: documentUrl))
                    .placeholder {
                        DefaultPlaceholder()
                    }
                    .resizable()
                    .scaledToFit()
                    .fullWidth()
                    .frame(height: 150)
                    .clipped()
            } else {
                image!
                    .resizable()
                    .scaledToFill()
                    .fullWidth()
                    .frame(height: 150)
                    .clipped()
            }

            Section {
                Text("Document ID").font(.subheadline).foregroundColor(.gray)

                EntryFieldWithValidation(sfSymbolName: "number", placeholder: "Document Number", prompt: viewModel.documentNumberPrompt, field: $viewModel.documentNumber)
                    .keyboardType(identityType.isNumeric ? UIKeyboardType.numberPad : UIKeyboardType.default)
                    .disabled(viewModel.isViewMode)
            }

            Section {
                Text("Search name").font(.subheadline).foregroundColor(.gray)
                TextField("Optional", text: $viewModel.searchName).disabled(viewModel.isViewMode)
            }
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                if viewModel.isViewMode {
                    Button {
                        viewModel.isViewMode = false
                    } label: {
                        Text("Edit")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isFormDataValid, !viewModel.isViewMode {
                    Button {
                        viewModel.uplaodDocument(docTypeId: identityType.id, docName: viewModel.searchName.isEmpty ? identityType.name : viewModel.searchName, jpegData: self.image.asUIImage().jpegData(compressionQuality: 0.0)!) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        if viewModel.isViewMode {
                            Text("Update")
                        } else {
                            Text("Add Document")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $shouldPresentImagePicker) {
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
        }
        .onChange(of: self.image, perform: { newValue in
            viewModel.imageData = newValue?.asUIImage().jpegData(compressionQuality: 0.0)
        })
        .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
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
