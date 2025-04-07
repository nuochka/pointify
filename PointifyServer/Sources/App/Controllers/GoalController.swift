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
            if goal.isCompleted {
                if let user = try await User.find(goal.userId, on: req.db) {
                    user.points += goal.points
                    try await user.save(on: req.db)
                }
            }

            try await goal.delete(on: req.db)
            return .ok
        }

        goals.patch(":goalId") { req async throws -> Goal in
            guard let goalId = req.parameters.get("goalId", as: UUID.self),
                  let goal = try await Goal.find(goalId, on: req.db) else {
                throw Abort(.notFound, reason: "Goal not found")
            }
            
            let data = try req.content.decode([String: Bool].self)
            
            if let isCompleted = data["isCompleted"] {
                if isCompleted && !goal.isCompleted {
                    goal.isCompleted = true
                    try await goal.save(on: req.db)

                    if let user = try await User.find(goal.userId, on: req.db) {
                        user.points -= goal.points
                        try await user.save(on: req.db)
                    }

                } else if !isCompleted && goal.isCompleted {
                    goal.isCompleted = false
                    try await goal.save(on: req.db)

                    if let user = try await User.find(goal.userId, on: req.db) {
                        user.points += goal.points
                        try await user.save(on: req.db)
                    }

                } else {
                    goal.isCompleted = isCompleted
                    try await goal.save(on: req.db)
                }
            }
            
            return goal
        }
    }
    
    func getAll(req: Request) async throws -> [Goal] {
        try await Goal.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Goal {
        let data = try req.content.decode([String: String].self)
            
        guard let userIdString = data["user_id"],
              let userId = UUID(uuidString: userIdString),
              let user = try await User.find(userId, on: req.db) else {
            throw Abort(.badRequest, reason: "Invalid user_id or user not found")
        }

        let title = data["title"] ?? ""
        let points = Int(data["points"] ?? "") ?? 0
        let isCompleted = Bool(data["isCompleted"] ?? "") ?? false

        let goal = Goal(title: title, isCompleted: isCompleted, points: points, userId: userId)
        try await goal.save(on: req.db)

        if isCompleted {
            user.points -= points
            try await user.save(on: req.db)
        }

        return goal
    }
}
