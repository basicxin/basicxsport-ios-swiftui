//
//  MobileOtpResponse.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 20/01/22.
//

import Foundation
import Networking
struct MobileOtpResponse: Codable {
    var status: Int
    var message: String
    var objectId: Int? // otp
}

extension MobileOtpResponse: NetworkingJSONDecodable {}
