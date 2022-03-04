//
//  ShopProductDetailView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 25/01/22.
//

import ACarousel
import Kingfisher 
import SwiftUI
struct ShopProductDetailView: View {
    @ObservedObject var viewModel = ShopProductDetailViewModel()
    @State var shouldShowCartView = false
    var productId: Int

    var body: some View {
        ScrollView {
            Group {
                NavigationLink(destination: CartView(cartType: Constants.ITEM_TYPE_MERCHANDISE), isActive: $shouldShowCartView) { EmptyView() }
            }

            VStack {
                if viewModel.shopProductDetail != nil {
                    let product = viewModel.shopProductDetail!

                    ACarousel(product.productImages, id: \.self, autoScroll: .active(10)) { images in
                        KFImage(URL(string: images.productImageURL))
                            .placeholder {
                                DefaultPlaceholder()
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                    }
                    .frame(height: 200)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.name)
                            .font(.title3)
                            .fontWeight(.medium)
                            .lineLimit(3)

                        Text(product.identifier)
                            .font(.callout)
                            .foregroundColor(.secondaryLabel)

                        Text(Constants.RUPEE + product.price.string)
                            .font(.title3)
                            .fontWeight(.bold)

                        Divider()
                        Text("About this item")
                            .font(.caption)
                            .foregroundColor(.secondaryLabel)

                        Text(product.itemDescription)
                    }.padding()
                }
            }
        }
        .frame(alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if viewModel.isProductInCart == true {
                        shouldShowCartView = true
                    } else {
                        viewModel.addToCart(objectId: productId, itemType: Constants.ITEM_TYPE_MERCHANDISE) {}
                    }
                } label: {
                    if viewModel.isProductInCart == true {
                        Text("Go to cart")
                    } else {
                        Text("Add to cart")
                    }
                }
            }
        }
        .navigationTitle("Product Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getShopProductDetail(productId: productId)
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
    }
}

struct ShopProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopProductDetailView(productId: 1)
                .navigationTitle("Product Detail")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
