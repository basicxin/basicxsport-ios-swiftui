//
//  ApplyCouponView.swift
//  BasicxSport
//
//  Created by Somesh K on 28/02/22.
//

import SwiftUI

struct ApplyCouponView: View {
    var salesId: Int
    @StateObject private var viewModel = ApplyCouponCodeViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 5) {
                EntryFieldWithValidation(sfSymbolName: "giftcard", placeholder: "Have a promo code? Enter here", prompt: "", field: $viewModel.couponCode)

                Button {
                    viewModel.applyCoupon(apiKey: UserDefaults.jwtKey, memberId: UserDefaults.memberId, couponCode: viewModel.couponCode, salesId: salesId) {
                        dismiss()
                    }
                } label: {
                    Text("Apply")
                }
                .disabled(!viewModel.isEnteredCouponCodeValid)
                .buttonStyle(.bordered)
                .padding(.bottom, 10)
            }
            .padding()

            Text("OR").padding()

            Text("Choose from the offers below")
                .font(.caption)
            if viewModel.couponList == nil {
                VStack {
                    Text("No Coupon Code Available")
                }.fullHeight()
            } else {
                List {
                    ForEach(viewModel.couponList!, id: \.self) { coupon in
                        VStack(alignment: .leading) {
                            Text(coupon.couponCode)

                            Text(coupon.couponDescription)
                                .font(.caption)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .offset(y: 2)
                        }
                        .onTapGesture {
                            viewModel.applyCoupon(apiKey: UserDefaults.jwtKey, memberId: UserDefaults.memberId, couponCode: coupon.couponCode, salesId: salesId) {
                                dismiss()
                            }
                        }
                        .fullWidth(alignement: .leading)
                    }
                }
                .listStyle(.inset)
            }
        }
        .fullSize(alignement: .top)
        .onAppear {
            viewModel.getCoupon()
        }.customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
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

struct ApplyCouponView_Previews: PreviewProvider {
    static var previews: some View {
        ApplyCouponView(salesId: 0)
    }
}
