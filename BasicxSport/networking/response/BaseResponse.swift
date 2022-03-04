//
//  BaseResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 07/01/22.
//

import Foundation
import Networking

struct BaseResponse<ResponseData: Codable>: Codable {
    let status: Bool
    let message: String
    let data: ResponseData?
}

extension BaseResponse: NetworkingJSONDecodable {}
