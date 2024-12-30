//
//  Ad_ManagerApp.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/26/24.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()

        return true
    }
}

@main
struct Ad_ManagerApp: App {
    @StateObject private var loginManager = LoginManager()

    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
//            NavigationStack {
                ContentView()
                    .environmentObject(loginManager)
//            }
        }
    }
}
