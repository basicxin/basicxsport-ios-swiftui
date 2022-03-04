//
//  SignUpResponse.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 20/01/22.
//

import Foundation
import Networking

struct SignUpResponse: Codable {
    var memberId: Int?, status: Int
    var lastName: String?, firstName: String?, jwtToken: String?, message: String, profilePictureUrl: String?, relationshipType: String?
}



extension SignUpResponse: NetworkingJSONDecodable {}
