//
//  DocumentListView.swift
//  BasicxSport
//
//  Created by Somesh K on 07/03/22.
//

import Kingfisher
import SwiftUI

struct DocumentListView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ZStack {
            if !viewModel.memberDocuments.isNilOrEmpty {
                List(viewModel.memberDocuments!, id: \.self) { document in
                    NavigationLink {
                        AddDocumentView(memberDocument: document)
                    } label: {
                        HStack(spacing: 10) {
                            KFImage(URL(string: document.docFileUrl))
                                .placeholder {
                                    DefaultPlaceholder()
                                }
                                .resizable()
                                .frame(width: 60, height: 60)
                                .scaledToFit()

                            VStack(alignment: .leading) {
                                Text(document.searchName).lineLimit(2)
                                Text(document.docIdentityNo)
                                    .fontWeight(.light)
                                    .font(.callout)
                                    .lineLimit(2)
                            }
                        }.fullWidth(alignement: .topLeading)
                    }
                }.listStyle(.plain)
            } else {
                Text("No Documents Available")
            }
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
        }.onAppear {
            viewModel.getDocuments()
        }
    }
}

struct DocumentListView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentListView()
    }
}
