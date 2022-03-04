//
//  ApplyCouponCodeResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 28/02/22.
//

import Foundation

struct PromoCodesResponse: Codable {
    let coupons: [Coupon]
}

// MARK: - Coupon

struct Coupon: Codable, Hashable {
    let id: Int
    let couponCode, couponDescription: String

    enum CodingKeys: String, CodingKey {
        case id, couponCode
        case couponDescription = "description"
    }
}
