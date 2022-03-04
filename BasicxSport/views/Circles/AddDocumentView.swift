//
//  AddDocumentView.swift
//  BasicxSport
//
//  Created by Somesh K on 05/02/22.
//

import MapKit
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
    var identityType: IdentityType

    init(identityType: IdentityType) {
        self.identityType = identityType
        viewModel.docRegex = identityType.identityIdRule
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
            }

            image!
                .resizable()
                .scaledToFill()
                .fullWidth()
                .frame(height: 150)
                .clipped()

            Section {
                Text("Document ID").font(.subheadline).foregroundColor(.gray)

                EntryFieldWithValidation(sfSymbolName: "number", placeholder: "Document Number", prompt: viewModel.documentNumberPrompt, field: $viewModel.documentNumber).keyboardType(
                    identityType.isNumeric ? UIKeyboardType.numberPad : UIKeyboardType.default)
            }

            Section {
                Text("Search name").font(.subheadline).foregroundColor(.gray)
                TextField("Optional", text: $viewModel.searchName)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isFormDataValid {
                    Button {
                        viewModel.uplaodDocument(docTypeId: identityType.id, docName: viewModel.searchName.isEmpty ? identityType.name : viewModel.searchName, jpegData: self.image.asUIImage().jpegData(compressionQuality: 0.1)!) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Add Document")
                    }
                }
            }
        }
        .sheet(isPresented: $shouldPresentImagePicker) {
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
        }
        .onChange(of: self.image, perform: { newValue in
            viewModel.imageData = newValue?.asUIImage().jpegData(compressionQuality: 0.2)
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
        .navigationTitle("Add Document")
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
