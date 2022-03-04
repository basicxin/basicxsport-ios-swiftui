//
//  RazorPayOrderRequest.swift
//  BASICX SPORT
//
//  Created by Somesh K on 04/01/22.
//

import Foundation

struct RazorPayOrderRequest: Encodable {
    let trxId, amount: String
}
