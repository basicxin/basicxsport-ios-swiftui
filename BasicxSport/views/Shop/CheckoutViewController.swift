//
//  CheckoutViewController.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import AppInvokeSDK
import SwiftUI

class CheckoutViewController: UIViewController, AIDelegate {
    private let appInvoke = AIHandler()

    var aiModel: AIModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = aiModel {
            print("🔶 CheckoutViewController viewDidLoad() openPaytm", model.orderId)
            appInvoke.openPaytm(merchantId: model.merchantId, orderId: model.orderId, txnToken: model.txnToken, amount: model.amount, callbackUrl: model.callbackUrl, delegate: self, environment: AIEnvironment.staging, urlScheme: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            print("🔶 Showing openPaymentWebVC")
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }

    func didFinish(with status: AIPaymentStatus, response: [String: Any]) {
        print("🔶 Paytm Callback Response: ", response)
        dismiss(animated: true)
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
