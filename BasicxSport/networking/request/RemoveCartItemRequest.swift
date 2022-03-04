//
//  RemoveCartItemRequest.swift
//  BASICX SPORT
//
//  Created by Somesh K on 06/01/22.
//

import Foundation
struct RemoveCartItemRequest: Encodable {
    let apiKey: String
    let lineItemId, objectId, memberId: Int
}
