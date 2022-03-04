//
//  PreferedSportView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 19/01/22.
//

import Kingfisher
import SwiftUI

struct PreferedSportView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CircleListViewModel
    private var columnGrid = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnGrid) {
                ForEach(viewModel.sports, id: \.self) { sport in
                    HStack {
                        KFImage(URL(string: sport.sportIconURL))
                            .placeholder { DefaultPlaceholder() }
                            .resizable()
                            .frame(width: 30, height: 30)

                        Text(sport.name).font(.subheadline)

                        Spacer()
                        if UserDefaults.preferredSportId == sport.id {
                            Image(systemName: "checkmark").foregroundColor(.green)
                        }
                    }.onTapGesture(perform: {
                        updatePreferedSports(sportId: sport.id)
                    })
                    .padding()
                    .background(.background)
                    .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)
                    .withDefaultShadow()
                }
            }
        }
        .padding()
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { currentAlert in
            Alert(
                title: Text("Alert"),
                message: Text(currentAlert.message),
                dismissButton: .default(Text("Ok")) {
                    currentAlert.dismissAction?()
                    dismiss()
                }
            )
        }
        .onChange(of: viewModel.succesfullyUpdatedPreferedSport, perform: { _ in
            dismiss()
        })
    }

    func updatePreferedSports(sportId: Int) {
        viewModel.updatePreferedSport(sportId: sportId)
    }
}

struct PreferedSportView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreferedSportView().environmentObject(CircleListViewModel())
        }
    }
}
