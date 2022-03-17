//
//  TournamentCategoryListView.swift
//  BasicxSport
//
//  Created by Somesh K on 14/03/22.
//

import SwiftUI

struct TournamentCategoryListView: View {
    @StateObject var viewModel = TournamentViewModel()
    @StateObject var cartViewModel = CartViewHolder()
    @State var shouldShowCartView = false
    var tournamentId: Int
    var body: some View {
        ZStack {
            Group {
                NavigationLink(destination: CartView(cartType: Constants.ITEM_TYPE_TOURNAMENT), isActive: $shouldShowCartView) { EmptyView() }
            }

            if !viewModel.tournamentCategoryList.isEmpty {
                List(viewModel.tournamentCategoryList, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Category").font(.footnote)
                            Spacer()
                            if category.isEnrolled {
                                Text("Enrolled").foregroundColor(.white).padding(5).background(.green).cornerRadius(5).font(.subheadline)
                            }
                        }

                        Text(category.name).font(.headline).padding(.bottom, 2)
                        Text(category.categoryDescription).font(.footnote).padding(.bottom, 5)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Format").font(.caption)
                                Text(category.matchFormat)
                            }

                            Spacer()

                            VStack {
                                if !viewModel.isCategoryNotOpen(category: category) {
                                    Text("Fee").font(.caption)
                                    Text(Constants.RUPEE + category.price.string).fontWeight(.bold)
                                }
                            }

                        }.padding(.bottom, 10)

                        HStack {
                            if category.isEligible, category.isEnrolled, !(category.seatType.caseInsensitiveCompare(Constants.Tournament.SEAT_TYPE_SINGLE) == .orderedSame) {
                                if category.seatType.caseInsensitiveCompare(Constants.Tournament.SEAT_TYPE_DOUBLE) == .orderedSame {
                                    Button {} label: {
                                        Text("My Partner")
                                    }.buttonStyle(.borderedProminent)
                                } else if category.seatType.caseInsensitiveCompare(Constants.Tournament.SEAT_TYPE_TEAM) == .orderedSame || category.seatType.caseInsensitiveCompare(Constants.Tournament.SEAT_TYPE_MIXED) == .orderedSame {
                                    Button {} label: {
                                        Text("My Team")
                                    }.buttonStyle(.borderedProminent)
                                }
                            }

                            Spacer()

                            if !viewModel.isCategoryNotOpen(category: category), category.isEligible, !category.isEnrolled {
                                Button {
                                    cartViewModel.addToCart(objectId: category.id, itemType: Constants.ITEM_TYPE_TOURNAMENT) {
                                        shouldShowCartView = true
                                    }
                                } label: {
                                    Text("Buy")
                                }.buttonStyle(.borderedProminent)
                            }
                        }.padding(.bottom, 10)
                    }
                }
                .listStyle(.plain)
            } else {
                Text("No categories available")
            }
        }
        .navigationTitle("Categories")
        .onAppear {
            viewModel.getTournamentCategories(tournamentId: tournamentId)
        }
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .customProgressDialog(isShowing: $cartViewModel.isLoading, progressContent: {
            ProgressView("Loading...")
        })
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text("Alert"),
                message: Text(alert.message),
                dismissButton: .default(Text("Ok")) {
                    alert.dismissAction?()
                }
            )
        }
    }
}

struct TournamentCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        TournamentCategoryListView(tournamentId: 0)
    }
}
