//
//  RazorPayView.swift
//  BasicxSport
//
//  Created by Somesh K on 21/03/22.
//

import Razorpay
import SwiftUI

struct RazorPayView: UIViewControllerRepresentable {
    var razorPayOptions: [String: Any] = [:]
    init() {
        razorPayOptions = ["": ""] // Razor pay options
    }

    func makeUIViewController(context: Context) -> RazorPayViewController {
        let controller = RazorPayViewController()
        controller.razorPayOptions = razorPayOptions
        return controller
    }

    func updateUIViewController(_ uiViewController: RazorPayViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: RazorPayView

        init(_ parent: RazorPayView) {
            self.parent = parent
            super.init()
        }
    }
}
