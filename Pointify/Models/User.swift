//
//  User.swift
//  Pointify
//
//  Created by nuochka on 01/04/2025.
//

import Foundation

struct User: Codable {
    let id: UUID
    let name: String
    let email: String
    let points: Int
}

