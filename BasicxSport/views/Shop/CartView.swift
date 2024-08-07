//
//  CartView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 27/01/22.
//

import Kingfisher
import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = CartViewHolder()
    @State var shouldProceedToCheckout = false
    @State var shouldShowApplyCouponView = false
    var cartType: String
    var timeInMillis : Int64 {
        let now = Date()
        return Int64(now.timeIntervalSince1970 * 1000)
    }
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.cart != nil, !viewModel.cart!.items.isEmpty {
                    let cart = viewModel.cart!
                    
                    Group {
                        NavigationLink(destination: ApplyCouponView(salesId: cart.id), isActive: $shouldShowApplyCouponView) { EmptyView() }
                    }
                    
                    LazyVStack {
                        ForEach(cart.items, id: \.self) { cartItem in
                            HStack {
                                KFImage(URL(string: cartItem.pictureURL))
                                    .placeholder { DefaultPlaceholder() }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .clipped()
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(cartItem.name)
                                        .lineLimit(3)
                                        .font(.subheadline)
                                    
                                    Text(cartItem.itemDescription)
                                        .lineLimit(3)
                                        .font(.caption)
                                    
                                    if cartItem.itemType.caseInsensitiveCompare(Constants.ITEM_TYPE_MERCHANDISE) == .orderedSame {
                                        Stepper {
                                            Text("Quantity \(cartItem.quantity.string)")
                                        } onIncrement: {
                                            viewModel.changeCartItemQuantity(lineItemId: cartItem.id, qty: cartItem.quantity + 1, cartType: cartType)
                                        } onDecrement: {
                                            if cartItem.quantity > 1 {
                                                viewModel.changeCartItemQuantity(lineItemId: cartItem.id, qty: cartItem.quantity - 1, cartType: cartType)
                                            }
                                        }
                                        .padding(.vertical)
                                    }
                                    HStack {
                                        Text(Constants.RUPEE + cartItem.price.string)
                                        Spacer()
                                        Image(systemName: "xmark.bin").foregroundColor(SwiftUI.Color.red)
                                            .onTapGesture {
                                                viewModel.removeItemFromCart(lineItemId: cartItem.id, objectId: cart.id, cartType: Constants.ITEM_TYPE_MERCHANDISE)
                                            }
                                    }
                                }
                            }
                            .fullWidth()
                            Divider()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        if !cart.promoCode.isEmpty {
                            HStack {
                                Text(cart.promoCode)
                                Spacer()
                                Image(systemName: "xmark")
                                    .onTapGesture {
                                        viewModel.clearCouponCode(objectId: cart.id) {
                                            viewModel.getCart(cartType: cartType)
                                        }
                                    }
                            }
                        } else {
                            Label("Apply Coupon", systemImage: "indianrupeesign.square")
                        }
                    }
                    .onTapGesture {
                        shouldShowApplyCouponView = true
                    }
                    .padding()
                    .fullWidth()
                    .withDefaultShadow()
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            Text("Subtotal").font(.subheadline)
                            Spacer()
                            Text(Constants.RUPEE + cart.subTotal.string)
                        }
                        HStack {
                            Text("Discount").font(.subheadline)
                            Spacer()
                            Text(Constants.RUPEE + cart.discount.string)
                        }
                        HStack {
                            Text("Other Charges").font(.subheadline)
                            Spacer()
                            Text(Constants.RUPEE + cart.otherCharges.string)
                        }
                        HStack {
                            Text("Tax").font(.subheadline)
                            Spacer()
                            Text(Constants.RUPEE + cart.tax.string)
                        }
                        HStack {
                            Text("Round off").font(.subheadline)
                            Spacer()
                            Text(Constants.RUPEE + cart.roundOff.asStringOrZero())
                        }
                        Divider()
                        
                        HStack {
                            Text("Total Payable Amount").font(.headline)
                            Spacer()
                            Text(Constants.RUPEE + cart.totalAmount.string).font(.headline)
                        }
                    }.fullWidth()
                    
                    Divider()
                }
            }
            .padding()
        }
        .background {
            Group {
                if viewModel.cart != nil {
                    let cart = viewModel.cart!
                    let orderNoWithTimestamp = (cart.orderNo + "_" + timeInMillis.description)
                    let callbackUrl = ("https://securegw-stage.paytm.in/" + "theia/paytmCallback?ORDER_ID=" + orderNoWithTimestamp)
                    
                    NavigationLink(
                        destination: PaymentView(orderNoWithTimestamp: orderNoWithTimestamp,
                                                 callbackUrl: callbackUrl,
                                                 value: (cart.totalAmount).string,
                                                 currency: "INR",
                                                 custId: UserDefaults.memberId.string,
                                                 redirectionTo: viewModel.redirectionTo),
                        isActive: $shouldProceedToCheckout
                    ) { EmptyView() }
                } else { EmptyView() }
            }
        }
        .onAppear {
            viewModel.getCart(cartType: cartType)
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
                    dismiss()
                }
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.cart != nil, !viewModel.cart!.items.isEmpty {
                    Button {
                        shouldProceedToCheckout = true
                    } label: {
                        Text("Checkout")
                    }
                }
            }
        }
        .onChange(of: viewModel.goBack, perform: { newValue in
            if newValue {
                dismiss()
            }
        })
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CartView(cartType: "String")
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Cart")
        }
    }
}
