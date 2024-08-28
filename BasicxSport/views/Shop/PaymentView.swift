//
//  PaymentView.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import Combine
import SwiftUI

struct PaymentView: View {
    @StateObject var viewModel = PaymentViewModel()
    
    var orderNoWithTimestamp: String
    var callbackUrl: String
    var value: String
    var currency: String
    var custId: String
    var redirectionTo: String
    @State var razorPayResponse: PaymentResponse? = nil
    
    @State private var showReceipt: Bool = false
    @State private var showPaymentSheet: Bool = false
    @State private var paymentID: String = ""
    @State private var paymentError: String? = nil
    
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if(showReceipt){
                    ReceiptView(
                        isSuccess:true,
                        amount: (value) ,
                        orderNumber: orderNoWithTimestamp,
                        txnId: paymentID
                    )
                }
                
                if paymentError != nil {
                    ReceiptView(
                        isSuccess:false,
                        amount: value ,
                        orderNumber: orderNoWithTimestamp,
                        txnId: paymentError!
                    )
                }
            }
            
        }.razorpayCheckoutSheet(
            isPresented: $showPaymentSheet,
            amount: (Int(value) ?? 0) * 100,
            razorPayOrderId: viewModel.razorPayOrderId ?? "",
            orderNoWithTimestamp: orderNoWithTimestamp,
            onSuccess: { paymentId in
                paymentID = paymentId
                showReceipt = true
            },
            onError: { code, description in
                paymentError = description
            }
        )
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
            // Convert value to a float and multiply by 100
            let amountInRuppes = (Float(value) ?? 0) * 100
            let formattedDate = Date().getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT)
            
            if amountInRuppes <= 0 {
                viewModel.sendPaymentTransaction(
                    apiKey: UserDefaults.jwtKey,
                    memberId: UserDefaults.memberId,
                    orderId: orderNoWithTimestamp,
                    amount: amountInRuppes.description,
                    createdDate: formattedDate,
                    paymentMethod: Constants.PROMO
                ) {
                    showReceipt = true
                }
            }
            else if(viewModel.razorPayOrderId == nil){
                viewModel.getOrderId(trxId:orderNoWithTimestamp,amount: amountInRuppes)
            }
        }
        .onChange(of: viewModel.razorPayOrderId) { newValue in
            if newValue != nil {
                showPaymentSheet.toggle()
            }
        }
        .navigationTitle("Checkout")
    }
}

struct ReceiptView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var refresh = Events.shared
    var isSuccess:  Bool
    var amount:  String
    var orderNumber:  String
    var txnId:  String
    var body: some View {
        VStack {
            Group {
                Image("basicxLogo").resizable().scaledToFit().frame(width: 100, height: 60)
                
                if (isSuccess) {
                    Text("Success").font(.title).foregroundColor(.green)
                } else {
                    Text("Failure").font(.title).foregroundColor(.red)
                }
                
                Text(Date().getFormattedDate(format: Constants.DateFormats.STANDARD_DATE_TIME_FORMAT)).fontWeight(.light)
            }
            
            Spacer()
            
            Group {
                Text("Amount Paid").fontWeight(.light)
                Text(Constants.RUPEE + amount).font(.largeTitle)
                
                
                Text("Order Id").fontWeight(.light).padding(.top, 5)
                Text(orderNumber).fontWeight(.semibold)
                
                
                Text("Bank Transaction Id").fontWeight(.light).padding(.top, 5)
                Text(txnId).fontWeight(.semibold)
                
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
            }.buttonStyle(.bordered)
        }
        .fullSize()
        .onAppear {
            refresh.newCirclePurchased = true
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(orderNoWithTimestamp: "", callbackUrl: "", value: "", currency: "", custId: "", redirectionTo: "", razorPayResponse: PaymentResponse(isSuccess: true, paymentId: "String", amount: "String",  orderNumber: "String"))
    }
}
