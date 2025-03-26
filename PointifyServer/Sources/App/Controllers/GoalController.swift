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
        goals.delete(":goalId") { req async throws -> HTTPStatus in
            guard let goalId = req.parameters.get("goalId", as: UUID.self) else {
                throw Abort(.badRequest, reason: "Invalid goal ID")
            }
            guard let goal = try await Goal.find(goalId, on: req.db) else {
                throw Abort(.notFound, reason: "Goal not found")
            }
                try await goal.delete(on: req.db)
                return .ok
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
