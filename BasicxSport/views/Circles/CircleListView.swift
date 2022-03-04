//
//  CircleListView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import Kingfisher
import SwifterSwift
import SwiftUI

struct CircleListView: View {
    @StateObject private var viewModel = CircleListViewModel()
    @State private var showPreferedSportSheet = false

    var body: some View {
        VStack {
            HeaderView(showPreferedSportSheet: $showPreferedSportSheet)

            List(viewModel.circles, id: \.self) { circles in
                NavigationLink {
                    CircleInfoView(circle: circles)
                } label: {
                    CircleRow(circles: circles)
                }

            }.sheet(isPresented: $showPreferedSportSheet) {
                PreferedSportView().environmentObject(viewModel)
            }
            .listStyle(.plain)
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
                }
            )
        }
    }
}

struct HeaderView: View {
    @Binding var showPreferedSportSheet: Bool
    var body: some View {
        HStack {
            KFImage(URL(string: UserDefaults.preferredSportLogoUrl))
                .placeholder {
                    DefaultPlaceholder()
                }
                .resizable()
                .frame(width: 30, height: 30)
                .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)

            Text(UserDefaults.preferredSportName)
                .font(.subheadline)

            Image(systemName: "chevron.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10, alignment: Alignment.center)
        }.onTapGesture {
            showPreferedSportSheet.toggle()
        }
    }
}

struct CircleRow: View {
    var circles: SearchedCircles
    var body: some View {
        HStack(alignment: .center) {
            KFImage(URL(string: circles.logoURL))
                .placeholder {
                    DefaultPlaceholder()
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)

            Text(circles.name).lineLimit(3).padding()
        }
    }
}

struct CircleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CircleListView()
        }
    }
}
