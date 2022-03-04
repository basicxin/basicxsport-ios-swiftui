//
//  RegistrationUser.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 20/01/22.
//

import Foundation

class RegistrationUser {
    static let shared = RegistrationUser()
    private init() {}

    var firstName: String?, lastName: String?, gender: String?, emailAddress: String?, password: String?, mobile: String?, dob: String?, os: String?, fcmToken: String?, deviceType: String?, appVer: String?, apiKey: String?
    var sportId: Int?, stateId: Int?, districtId: Int?
}
