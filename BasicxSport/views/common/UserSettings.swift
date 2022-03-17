//
//  UserSettings.swift
//  BasicxSport
//
//  Created by Somesh K on 03/02/22.
//

import Combine
import SwiftUI

class UserSettings: ObservableObject {
    @Published var loggedIn: Bool = false
    @Published var refreshView: Bool = false

    init() {
        loggedIn = UserDefaults.isLoggedIn
    }
}
