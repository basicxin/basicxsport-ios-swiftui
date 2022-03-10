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
    
    // this is the binding that we receive from the SwiftUI side
    let response: Binding<[String: Any]>
  
    // this will be the delegate of the view controller, it's role is to allow
      // the data transfer from UIKit to SwiftUI
      class Coordinator: ViewControllerDelegate {
          let paytmResponseBinding: Binding<[String: Any]>
          
          init(responseBinding: Binding<[String: Any]>) {
              self.paytmResponseBinding = responseBinding
          }
          
          func onPaymentResponseRecieved(_ viewController: CheckoutViewController, response: [String: Any]) {
              // whenever the view controller notifies it's delegate about receiving a new idenfifier
              // the line below will propagate the change up to SwiftUI
              paytmResponseBinding.wrappedValue = response
          }
      }
 
    func makeUIViewController(context: Context) -> CheckoutViewController {
        let vc = CheckoutViewController()
        vc.aiModel = aiModel
        vc.responseDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: CheckoutViewController, context: Context) {
        typealias UIViewControllerType = CheckoutViewController
    }
    
    // this is very important, this coordinator will be used in `makeUIViewController`
       func makeCoordinator() -> Coordinator {
           Coordinator(responseBinding: response)
       }
}
