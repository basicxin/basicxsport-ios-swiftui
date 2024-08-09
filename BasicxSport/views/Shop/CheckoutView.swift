//
//  CheckoutView.swift
//  BasicxSport
//
//  Created by BASICX Admin on 06/08/24.
//

import SwiftUI
import Razorpay

struct CheckoutView: UIViewControllerRepresentable {
    @Binding private var isPresented: Bool
    private let onSuccess: (_ paymentId: String) -> ()
    private let onError: (_ code: Int32, _ description: String) -> ()
    private let amount: Int
    private let razorPayOrderId: String
    private let orderNoWithTimestamp: String
    
    init(
        isPresented: Binding<Bool>,
        amount: Int,
        razorPayOrderId: String,
        orderNoWithTimestamp: String,
        onSuccess: @escaping (_ paymentId: String) -> (),
        onError: @escaping (_ code: Int32, _ description: String) -> ()
    ) {
        self._isPresented = isPresented
        self.onSuccess = onSuccess
        self.onError = onError
        self.amount = amount
        self.razorPayOrderId = razorPayOrderId
        self.orderNoWithTimestamp = orderNoWithTimestamp
    }
    
    func makeUIViewController(context: Context) -> CheckoutViewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {
        if isPresented {
            context.coordinator.showPaymentSheet(amount: amount, razorPayOrderId: razorPayOrderId, orderNoWithTimestamp: orderNoWithTimestamp)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            self,
            onSuccess: { paymentId in
                isPresented = false
                onSuccess(paymentId)
            },
            onError: { code, description in
                isPresented = false
                onError(code, description)
            }
        )
    }
    
    class Coordinator: NSObject, RazorpayPaymentCompletionProtocol, RazorpayPaymentCompletionProtocolWithData {
        
        private let onSuccess: (_ paymentId: String) -> ()
        private let onError: (_ code: Int32, _ description: String) -> ()
        
        func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
            onError(code, str)
        }
        
        func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
            onSuccess(payment_id)
        }
        
        let parent: CheckoutView
        
        var razorpayObj: RazorpayCheckout? = nil
        
        typealias Razorpay = RazorpayCheckout
        var razorpay: RazorpayCheckout!
          
        init(
            _ parent: CheckoutView,
            onSuccess: @escaping (_ paymentId: String) -> (),
            onError: @escaping (_ code: Int32, _ description: String) -> ()
        ) {
            self.parent = parent
            self.onSuccess = onSuccess
            self.onError = onError
        }
        
        func showPaymentSheet(amount: Int, razorPayOrderId: String, orderNoWithTimestamp: String) {
            if razorPayOrderId.isEmpty   {
                onError(-1, "Invalid Razorpay Order Id")
                return
            }
            
            razorpayObj = RazorpayCheckout.initWithKey(
                DynamicValues.razorPaykey,
                andDelegate: self
            ) 
            let options: [String: Any] = [
                "prefill": [
                    "contact": UserDefaults.phoneNo,
                    "email": UserDefaults.email,
                    "name": UserDefaults.userFirstName
                ],
                "amount": amount,
                "description": orderNoWithTimestamp,
                "currency": "INR",
                "send_sms_hash": false,
                "remember_customer": false,
                "name": "BASICX SPORT",
                "key":   DynamicValues.razorPaykey,
                "order_id": razorPayOrderId,
                "image": "https://basicxsports.in/logo.png",
                "theme": [
                    "color": "#000000"
                ]
            ]
            if let rzp = self.razorpayObj {
                rzp.open(options)
            } else {
                onError(-1, "Unable to initialize")
            }
        }
        
        func onPaymentError(_ code: Int32, description str: String) {
            onError(code, str)
        }
        
        func onPaymentSuccess(_ payment_id: String) {
            onSuccess(payment_id)
        }
    }
}

class CheckoutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}


struct PaymentResponse: Codable, Hashable {
    let isSuccess: Bool
    let paymentId: String
    let amount: String
    let orderNumber: String
}
