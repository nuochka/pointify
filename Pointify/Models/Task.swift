//
//  Task.swift
//  Pointify
//
//  Created by nuochka on 23/03/2025.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var points: Int
    var userId: UUID
}
