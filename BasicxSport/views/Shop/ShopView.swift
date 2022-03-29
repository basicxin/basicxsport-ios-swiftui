//
//  ShopView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 17/01/22.
//

import Kingfisher
import SwiftUI

struct ShopView: View {
    @ObservedObject var viewModel = ShopViewModel()
    private var columnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    @State var shouldShowCartView = false
    @StateObject var refresh = Events.shared

    var body: some View {
        ScrollView {
            ZStack {
                if !viewModel.shopProductList.isEmpty {
                    LazyVGrid(columns: columnGrid) {
                        ForEach(viewModel.shopProductList, id: \.self) { product in
                            NavigationLink {
                                ShopProductDetailView(productId: product.id)
                            } label: {
                                VStack {
                                    KFImage(URL(string: product.itemPictureURL))
                                        .placeholder { DefaultPlaceholder() }
                                        .cancelOnDisappear(true)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 150)
                                        .clipped()

                                    Text(product.name)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .frame(height: 60)
                                        .padding(.horizontal, 2)
                                }
                                .cornerRadius(Constants.Size.DEFAULT_CORNER_RADIUS)
                                .withDefaultShadow()
                            }
                        }
                    }
                } else {
                    Text(Constants.NoData)
                }
            }.fullSize()
        }
        .background {
            Group {
                NavigationLink(destination: CartView(cartType: Constants.ITEM_TYPE_MERCHANDISE), isActive: $shouldShowCartView) { EmptyView() }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shouldShowCartView = true
                } label: {
                    if viewModel.cartItemCount > 0 {
                        Text("Go to cart")
                    }
                }
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
        }
        .onReceive(refresh.$myCircleChanged, perform: { isCircleChanged in
            if isCircleChanged {
                viewModel.getShopProducts()
            }
        })
        .onReceive(refresh.$newCirclePurchased, perform: { newCirclePurchased in
            if newCirclePurchased {
                viewModel.getShopProducts()
            }
        })
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
