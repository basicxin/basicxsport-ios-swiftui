//
//  RegisterNewUserRequest.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 20/01/22.
//

import Foundation
struct RegisterNewUserRequest: Codable {
    var firstName: String, lastName: String, title: String, gender: String, emailAddress: String, password: String, mobile: String, dob: String, os: String, token: String, deviceType: String, appVer: String, apiKey: String
    var sportId: Int, stateId: Int, districtId: Int
}

struct RegisterNewChildRequest: Codable {
    var apiKey: String, firstName: String, lastName: String, title: String, gender: String, dob: String, os: String
    var memberId: Int, sportId: Int, stateId: Int, districtId: Int
}
