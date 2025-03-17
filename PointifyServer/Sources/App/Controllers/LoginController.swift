//
//  LoginController.swift
//  PointifyServer
//
//  Created by nuochka on 17/03/2025.
//

import Vapor
import Fluent

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let loginRoute = routes.grouped("login")
        loginRoute.post(use: login)
    }
    
    @Sendable
    func login(req: Request) async throws -> HTTPStatus{
        let data = try req.content.decode(LoginRequest.self)
        
        guard data.email.contains("@"), data.password.count >= 6 else {
            throw Abort(.badRequest, reason: "Invalid input.")
        }
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == data.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }
        
        let isPasswordCorrect = try Bcrypt.verify(data.password, created: user.password)
        if !isPasswordCorrect {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }
        return .ok
    }
}
