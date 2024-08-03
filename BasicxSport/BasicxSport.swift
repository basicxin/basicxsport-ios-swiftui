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
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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
            HomeView().environmentObject(settings)
        } else {
            NavigationView {
                LoginView().environmentObject(settings)
            }
        }
    }
}
