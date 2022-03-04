//
//  BaseResponseAIM.swift
//  BASICX SPORT
//
//  Created by Somesh K on 14/12/21.
//

import Foundation
import Networking

struct DefaultResponseAIM: Codable {
    let status: Int
    let message: String
}

extension DefaultResponseAIM: NetworkingJSONDecodable {}
