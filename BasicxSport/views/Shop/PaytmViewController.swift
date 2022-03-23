//
//  PaytmViewController.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 28/01/22.
//

import AppInvokeSDK
import Razorpay
import SwiftUI


class PaytmViewController: UIViewController, AIDelegate {
    weak var responseDelegate: ViewControllerDelegate?
    private let appInvoke = AIHandler()

    var aiModel: AIModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let model = aiModel {
            appInvoke.openPaytm(merchantId: model.merchantId, orderId: model.orderId, txnToken: model.txnToken, amount: model.amount, callbackUrl: model.callbackUrl, delegate: self, environment: AIEnvironment.staging, urlScheme: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }

    func didFinish(with status: AIPaymentStatus, response: [String: Any]) {
        responseDelegate?.onPaymentResponseRecieved(self, response: response)
        dismiss(animated: true)
    }
}
protocol ViewControllerDelegate: AnyObject {
    func onPaymentResponseRecieved(_ viewController: PaytmViewController, response: [String: Any])
}
