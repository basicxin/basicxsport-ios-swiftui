//
//  AddToCartRequest.swift
//  BASICX SPORT
//
//  Created by Somesh K on 22/12/21.
//

import Foundation
struct AddToCartRequest: Encodable {
    let apiKey, itemType: String
    let memberId, objectId: Int
}
