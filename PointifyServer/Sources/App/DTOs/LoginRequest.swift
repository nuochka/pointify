//
//  LoginRequest.swift
//  PointifyServer
//
//  Created by nuochka on 17/03/2025.
//
import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}
