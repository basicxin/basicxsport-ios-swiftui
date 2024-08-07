//
//  ViewExtension.swift
//  BasicxSport
//
//  Created by BASICX Admin on 06/08/24.
//

import SwiftUI

public extension View {
    func razorpayCheckoutSheet(
        isPresented: Binding<Bool>,
        amount: Int,
        razorPayOrderId: String,
        orderNoWithTimestamp: String,
        onSuccess: @escaping (_ paymentId: String) -> (),
        onError: @escaping (_ code: Int32, _ description: String) -> ()
    ) -> some View {
        if #available(iOS 15.0, *) {
            return overlay {
                CheckoutView(
                    isPresented: isPresented,
                    amount: amount,
                    razorPayOrderId: razorPayOrderId,
                    orderNoWithTimestamp: orderNoWithTimestamp,
                    onSuccess: onSuccess,
                    onError: onError
                )
                .allowsHitTesting(false)
            }
        } else {
            return ZStack {
                CheckoutView(
                    isPresented: isPresented,
                    amount: amount,
                    razorPayOrderId: razorPayOrderId,
                    orderNoWithTimestamp: orderNoWithTimestamp,
                    onSuccess: onSuccess,
                    onError: onError
                )
                .allowsHitTesting(false)
            }
            .opacity(0)
        }
    }
}
