//
//  CheckoutView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject var viewModel = CheckoutViewModel()
    var orderId: String
    var callbackUrl: String
    var value: String
    var currency: String
    var custId: String
    var redirectionTo: String

    var body: some View {
        ZStack {
            if viewModel.paytmToken != nil {
                PaytmView(orderId: orderId, txnToken: viewModel.paytmToken!, amount: value, callbackUrl: callbackUrl)
                    .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            viewModel.getPaytmToken(orderId: orderId, callbackUrl: callbackUrl, value: value, currency: currency, custId: custId)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderId: "", callbackUrl: "", value: "", currency: "", custId: "", redirectionTo: "")
    }
}
