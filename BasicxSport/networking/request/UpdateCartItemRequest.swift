//
//  UpdateCartItemRequest.swift
//  BASICX SPORT
//
//  Created by Somesh K on 06/01/22.
//

import Foundation

struct UpdateCartItemRequest: Encodable {
    let apiKey, qty: String
    let lineItemId, memberId: Int
}
