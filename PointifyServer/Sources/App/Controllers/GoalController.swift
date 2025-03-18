//
//  GoalController.swift
//  PointifyServer
//
//  Created by nuochka on 18/03/2025.
//
import Vapor
import Fluent

final class GoalController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let goals = routes.grouped("goals")
        
        goals.get { req async throws -> [Goal] in
            try await self.getAll(req: req)
        }

        goals.post { req async throws -> Goal in
            try await self.create(req: req)
        }
    }
    
    func getAll(req: Request) async throws -> [Goal] {
        try await Goal.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Goal {
        let data = try req.content.decode([String: String].self)
            
        guard let userIdString = data["user_id"],
            let userId = UUID(uuidString: userIdString) else {
            throw Abort(.badRequest, reason: "Invalid user_id format")
        }

        let title = data["title"] ?? ""
        let points = Int(data["points"] ?? "") ?? 0
        let isCompleted = Bool(data["isCompleted"] ?? "") ?? false

        let goal = Goal(title: title, isCompleted: isCompleted, points: points, userId: userId)
        try await goal.save(on: req.db)

        return goal
    }
}
