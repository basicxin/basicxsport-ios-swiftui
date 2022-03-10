//
//  CheckoutView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import Combine
import SwiftUI

struct CheckoutView: View {
    @StateObject var viewModel = CheckoutViewModel()
    var orderNoWithTimestamp: String
    var callbackUrl: String
    var value: String
    var currency: String
    var custId: String
    var redirectionTo: String
    @State var paytmResponse: [String: Any] = [:]

    var body: some View {
        ZStack {
            if viewModel.paytmToken != nil {
                VStack {
                    PaytmView(aiModel: AIModel(merchantId: "IzTqME52588233114427", orderId: orderNoWithTimestamp, txnToken: viewModel.paytmToken!, amount: value, callbackUrl: callbackUrl), response: $paytmResponse)
                        .navigationBarHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }

            if paytmResponse.isEmpty {
                EmptyView()
            } else {
                ReceiptView(paytmResponse: paytmResponse)
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

struct ReceiptView: View {
    @Environment(\.dismiss) var dismiss
    var paytmResponse: [String: Any]
    var body: some View {
        VStack {
            Group {
                Image("basicxLogo").resizable().scaledToFit().frame(width: 100, height: 60)

                if (paytmResponse["STATUS"] as! String).contains("SUCCESS", caseSensitive: false) {
                    Text("Success").font(.title).foregroundColor(.green)
                } else {
                    Text("Failure").font(.title).foregroundColor(.red)
                }

                Text(Date().getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT)).fontWeight(.light)
            }

            Spacer()

            Group {
                Text("Amount Paid").fontWeight(.light)
                if (paytmResponse["STATUS"] as! String).contains("SUCCESS", caseSensitive: false) {
                    let amount = paytmResponse["TXNAMOUNT"] as! String
                    Text(Constants.RUPEE + amount).font(.largeTitle)
                } else {
                    Text("N/A").fontWeight(.semibold)
                }

                Text("Order Id").fontWeight(.light).padding(.top, 5)

                if (paytmResponse["STATUS"] as! String).contains("SUCCESS", caseSensitive: false) {
                    let orderId = paytmResponse["ORDERID"] as! String
                    Text(orderId).fontWeight(.semibold)
                } else {
                    Text("N/A").fontWeight(.semibold)
                }

                Text("Bank Transaction Id").fontWeight(.light).padding(.top, 5)
                if (paytmResponse["STATUS"] as! String).contains("SUCCESS", caseSensitive: false) {
                    let bankTxnId = paytmResponse["BANKTXNID"] as! String
                    Text(bankTxnId).fontWeight(.semibold)
                } else {
                    Text("N/A").fontWeight(.semibold)
                }
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
            }.buttonStyle(.borderedProminent)

        }.fullSize()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderNoWithTimestamp: "", callbackUrl: "", value: "", currency: "", custId: "", redirectionTo: "")
    }
}
