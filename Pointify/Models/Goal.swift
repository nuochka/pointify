//
//  Goal.swift
//  Pointify
//
//  Created by nuochka on 18/03/2025.
//

import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var points: Int
    var userId: UUID
}
