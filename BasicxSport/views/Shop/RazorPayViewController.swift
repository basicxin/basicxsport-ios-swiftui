//
//  RazorPayViewController.swift
//  BasicxSport
//
//  Created by Somesh K on 21/03/22.
//

import Razorpay
import UIKit

class RazorPayViewController: UIViewController, RazorpayPaymentCompletionProtocolWithData {
    
    private var razorpay: RazorpayCheckout!
    private let razorPayKey = "rzp_test_fm8b0zG8AY3Tgw"
    var razorPayOptions: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = RazorpayCheckout.initWithKey(razorPayKey, andDelegateWithData: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showPaymentForm()
    }

    internal func showPaymentForm() {
        let options: [String: Any] = razorPayOptions
        razorpay.open(options)
    }

    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable: Any]?) {}

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable: Any]?) {}
}
