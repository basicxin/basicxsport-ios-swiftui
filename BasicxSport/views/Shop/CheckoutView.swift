//
//  CheckoutView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject var viewModel = CheckoutViewModel()
    var orderNoWithTimestamp: String
    var callbackUrl: String
    var value: String
    var currency: String
    var custId: String
    var redirectionTo: String

    var body: some View {
        ZStack {
            if viewModel.paytmToken != nil {
                let prnt = print("🔶 got orderId on CheckoutView", orderNoWithTimestamp)
                PaytmView(aiModel: AIModel(merchantId: "IzTqME52588233114427", orderId: orderNoWithTimestamp, txnToken: viewModel.paytmToken!, amount: value, callbackUrl: callbackUrl))
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .customProgressDialog(isShowing: $viewModel.isLoading, progressContent: {
            ProgressView("Loading Merchant...")
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
        .onAppear {
            viewModel.getPaytmToken(orderId: orderNoWithTimestamp, callbackUrl: callbackUrl, value: value, currency: currency, custId: custId)
        }
        .navigationTitle("Checkout")
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderNoWithTimestamp: "", callbackUrl: "", value: "", currency: "", custId: "", redirectionTo: "")
    }
}
