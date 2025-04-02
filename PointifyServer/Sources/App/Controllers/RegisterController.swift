//
//  RegisterController.swift
//  PointifyServer
//
//  Created by nuochka on 16/03/2025.
//

import Vapor
import Fluent

struct RegisterController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let registerRoute = routes.grouped("register")
        registerRoute.post(use: register)
    }

    @Sendable
    func register(req: Request) async throws -> HTTPStatus {
        let data = try req.content.decode(RegisterRequest.self)
        
        guard data.name.count > 1,
              data.email.contains("@"),
              data.password.count >= 6 else {
            throw Abort(.badRequest, reason: "Invalid input.")
        }

        if try await User.query(on: req.db).filter(\.$email == data.email).first() != nil {
            throw Abort(.conflict, reason: "Email already registered.")
        }

        let passwordHash = try Bcrypt.hash(data.password)

        let user = User(name: data.name, email: data.email, password: passwordHash, points: 0)
        try await user.save(on: req.db)

        return .created
    }
}

