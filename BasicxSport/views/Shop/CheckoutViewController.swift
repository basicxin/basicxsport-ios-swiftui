//
//  CheckoutViewController.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import AppInvokeSDK
import SwiftUI

struct PaytmView: UIViewControllerRepresentable {
    var orderId: String
    var txnToken: String
    var amount: String
    var callbackUrl: String
    func makeUIViewController(context: Context) -> CheckoutViewController {
        let vc = CheckoutViewController()
        vc.orderId = orderId
        vc.txnToken = txnToken
        vc.amount = amount
        vc.callbackUrl = callbackUrl
        return vc
    }

    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {}

    typealias UIViewControllerType = CheckoutViewController
}

class CheckoutViewController: UIViewController, AIDelegate {
    var merchentID = "IzTqME52588233114427"
    var orderId: String = ""
    var txnToken: String = ""
    var amount: String = ""
    var callbackUrl: String = ""

    private let appInvoke = AIHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        appInvoke.openPaytm(merchantId: merchentID, orderId: orderId, txnToken: txnToken, amount: amount, callbackUrl: callbackUrl, delegate: self, environment: AIEnvironment.staging, urlScheme: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            print("Showing openPaymentWebVC")
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }

    func didFinish(with status: AIPaymentStatus, response: [String: Any]) {
        print("🔶 Paytm Callback Response: ", response)
    }
}

// struct RazorPayView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> CheckoutViewController {
//        .init()
//    }
//
//    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, RazorpayPaymentCompletionProtocol {
//        let parent: RazorPayView
//
//        typealias Razorpay = RazorpayCheckout
//        var razorpay: RazorpayCheckout!
//
//        init(_ parent: RazorPayView) {
//            self.parent = parent
//            super.init()
//            RazorpayCheckout.initWithKey("rzp_test_OD7UqFZXAstzsD", andDelegate: self)
//        }
//
//        func onPaymentError(_ code: Int32, description str: String) {
//            print("error: ", code, str)
//            //   self.presentAlert(withTitle: "Alert", message: str)
//            // parent.alert with message
//        }
//
//        func onPaymentSuccess(_ payment_id: String) {
//            print("success: ", payment_id)
//            //   self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
//        }
//    }
// }
//
// class CheckoutViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //  self.showPaymentForm()
//    }
// }
