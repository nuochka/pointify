//
//  RegisterRequest.swift
//  PointifyServer
//
//  Created by nuochka on 16/03/2025.
//

import Vapor

struct RegisterRequest: Content {
    let name: String
    let email: String
    let password: String
}
