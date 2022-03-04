//
//  PaytmView.swift
//  BasicxSport
//
//  Created by Somesh K on 04/03/22.
//

import Foundation
import SwiftUI

struct PaytmView: UIViewControllerRepresentable {
    var aiModel: AIModel

    func makeUIViewController(context: Context) -> CheckoutViewController {
        let vc = CheckoutViewController()
        vc.aiModel = aiModel
        return vc
    }

    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {}

    typealias UIViewControllerType = CheckoutViewController
}
