//
//  PointifyApp.swift
//  Pointify
//
//  Created by nuochka on 10/03/2025.
//

import SwiftUI
import Foundation


@main
struct PointifyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension UserDefaults {
    func saveUserId(_ userId: UUID) {
        set(userId.uuidString, forKey: "userId")
    }

    func getUserId() -> UUID? {
        guard let userIdString = string(forKey: "userId"),
              let userId = UUID(uuidString: userIdString) else {
            return nil
        }
        return userId
    }
}

