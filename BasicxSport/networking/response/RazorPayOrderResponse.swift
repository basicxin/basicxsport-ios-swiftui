//
//  RazorPayOrderResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 04/01/22.
//

import Foundation

// MARK: - DataClass

struct RazorPayOrderResponse: Codable {
    let razorPayOrderId: String
    enum CodingKeys: String, CodingKey {
        case razorPayOrderId = "id"
    }
}
