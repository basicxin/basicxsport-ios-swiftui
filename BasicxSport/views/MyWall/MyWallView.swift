//
//  MyWallView.swift
//  BasicxSport
//
//  Created by Somesh K on 21/03/22.
//

import SwiftUI

struct MyWallView: View {
    @StateObject var viewModel = MyWallViewModel()
    private var columnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.myWallResponse != nil {
                    LazyVGrid(columns: columnGrid) {
                        ForEach(viewModel.myWallResponse!.stats, id: \.self) { wallStats in
                            HStack {
                                WallStatsView(statsName: wallStats.name, statsCount: wallStats.count)
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }.fullSize()
            .onAppear {
                viewModel.getMyWall()
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
            .navigationTitle("My Wall")
    }
}

struct MyWallView_Previews: PreviewProvider {
    static var previews: some View {
        MyWallView()
    }
}

struct WallStatsView: View {
    var statsName: String
    var statsCount: Int

    var body: some View {
        VStack {
            Text(statsCount.string).font(.largeTitle)
            Text(statsName)
        }
        .fullWidth()
        .padding()
        .withDefaultShadow()
    }
}
