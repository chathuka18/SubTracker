//
//  SubTrackerApp.swift
//  SubTracker
//
//  Created by Chathuka Gamage on 2025-10-30.
//

import SwiftUI
import SwiftData

@main
struct SubTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Subscription.self)
    }
}
