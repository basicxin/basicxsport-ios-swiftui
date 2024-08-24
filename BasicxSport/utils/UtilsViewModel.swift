//
//  UtilsViewModel.swift
//  BasicxSport
//
//  Created by BASICX Admin on 17/08/24.
//

import Foundation
import UserNotifications
import SwiftUI
 
@MainActor final
class UtilsViewModel: ObservableObject {
    @Published var hasPermission = false
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            self.hasPermission = true
        default:
            self.hasPermission = false
        }
    }
    
    func requestNotificationPermission() async {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)

            UIApplication.shared.registerForRemoteNotifications()
        } catch {
            print(error.localizedDescription)
        }
    }
} 
