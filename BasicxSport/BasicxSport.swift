//
//  BasicxSportSwiftUIApp.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 10/01/22.
//

import SwiftUI

@main
struct BasicxSport: App {
    @StateObject var settings = UserSettings()

    var body: some Scene {
        WindowGroup {
            ApplicationSwitcher()
                .environmentObject(settings)
        }
    }
}

struct ApplicationSwitcher: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        if settings.loggedIn {
            let prnt  = print("inside logged in UserSettings")
            HomeView().environmentObject(settings)
        } else {
            NavigationView {
                let prnt  = print("inside logged out UserSettings")
                LoginView().environmentObject(settings)
            }
        }
    }
}
