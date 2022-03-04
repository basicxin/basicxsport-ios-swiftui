//
//  SignInRequest.swift
//  BASICX SPORT
//
//  Created by Somesh K on 03/12/21.
//

import Foundation

// MARK: - Welcome

struct SignInRequest: Codable {
    var appVer: String, deviceType: String, emailAddress: String, fcmToken: String, os: String, password: String
}
