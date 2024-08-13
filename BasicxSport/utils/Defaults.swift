//
//  Defaults.swift
//  BASICX SPORT
//
//  Created by Somesh K on 16/12/21.
//

import Foundation
extension UserDefaults {
    private enum Keys {
        static let jwtKey = "jwtKey"
        static let isLoggedIn = "isLoggedIn"
        static let memberId = "memberId"
        static let userFirstName = "userFirstName"
        static let userLastName = "userLastName"
        static let email = "email"
        static let phoneNo = "phoneNo"
        static let profilePictureUrl = "profilePictureUrl"
        static let relationshipType = "relationshipType"
        static let preferredSportId = "preferredSportId"
        static let preferredSportName = "preferredSportName"
        static let preferredSportLogoUrl = "preferredSportLogoUrl"
        static let preferredCircleId = "preferredCircleId"
    }

    class var jwtKey: String {
        get { UserDefaults.standard.string(forKey: Keys.jwtKey) ?? DynamicValues.staticKey}
        set { UserDefaults.standard.set(newValue, forKey: Keys.jwtKey) }
    }

    class var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isLoggedIn) }
    }

    class var memberId: Int {
        get { UserDefaults.standard.integer(forKey: Keys.memberId) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.memberId) }
    }

    class var userFirstName: String {
        get { UserDefaults.standard.string(forKey: Keys.userFirstName) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userFirstName) }
    }

    class var userLastName: String {
        get { UserDefaults.standard.string(forKey: Keys.userLastName) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userLastName) }
    }

    class var email: String {
        get { UserDefaults.standard.string(forKey: Keys.email) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.email) }
    }

    class var phoneNo: String {
        get { UserDefaults.standard.string(forKey: Keys.phoneNo) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.phoneNo) }
    }

    class var profilePictureUrl: String {
        get { UserDefaults.standard.string(forKey: Keys.profilePictureUrl) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.profilePictureUrl) }
    }

    class var relationshipType: String {
        get { UserDefaults.standard.string(forKey: Keys.relationshipType) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.relationshipType) }
    }

    class var preferredSportId: Int {
        get { UserDefaults.standard.integer(forKey: Keys.preferredSportId) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.preferredSportId) }
    }

    class var preferredSportName: String {
        get { UserDefaults.standard.string(forKey: Keys.preferredSportName) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.preferredSportName) }
    }

    class var preferredSportLogoUrl: String {
        get { UserDefaults.standard.string(forKey: Keys.preferredSportLogoUrl) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: Keys.preferredSportLogoUrl) }
    }

    class var preferredCircleId: Int {
        get { UserDefaults.standard.integer(forKey: Keys.preferredCircleId) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.preferredCircleId) }
    }
}
