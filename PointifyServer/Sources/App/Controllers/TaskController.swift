//
//  TaskController.swift
//  PointifyServer
//
//  Created by nuochka on 23/03/2025.
//

import Vapor
import Fluent

final class TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")
        
        tasks.get { req async throws -> [Task] in
            try await self.getAll(req: req)
        }

        tasks.post { req async throws -> Task in
            try await self.create(req: req)
        }
        tasks.delete(":taskId") { req async throws -> HTTPStatus in
            guard let taskId = req.parameters.get("taskId", as: UUID.self) else {
                throw Abort(.badRequest, reason: "Invalid task ID")
            }
            guard let task = try await Task.find(taskId, on: req.db) else {
                throw Abort(.notFound, reason: "Task not found")
            }
                try await task.delete(on: req.db)
                return .ok
            }
    }
    
    func getAll(req: Request) async throws -> [Task] {
        try await Task.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Task {
        let data = try req.content.decode([String: String].self)
            
        guard let userIdString = data["user_id"],
            let userId = UUID(uuidString: userIdString) else {
            throw Abort(.badRequest, reason: "Invalid user_id format")
        }

        let title = data["title"] ?? ""
        let points = Int(data["points"] ?? "") ?? 0
        let isCompleted = Bool(data["isCompleted"] ?? "") ?? false

        let task = Task(title: title, isCompleted: isCompleted, points: points, userId: userId)
        try await task.save(on: req.db)

        return task
    }
}
