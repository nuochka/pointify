import Vapor
import Fluent

struct UserPointsResponse: Content {
    let totalPoints: Int
}

final class UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.get(":userId", "points") { req async throws -> UserPointsResponse in
            guard let userId = req.parameters.get("userId", as: UUID.self),
                let user = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound, reason: "User not found")
            }
            print("Points: \(user.id!): \(user.points)")
            return UserPointsResponse(totalPoints: user.points)
        }
        
        users.put(":userId", "points") { req async throws -> HTTPStatus in
            guard let userId = req.parameters.get("userId", as: UUID.self) else {
                throw Abort(.badRequest, reason: "Invalid user ID")
            }

            guard let user = try await User.find(userId, on: req.db) else {
                throw Abort(.notFound, reason: "User not found")
            }

            let updateData = try req.content.decode(UserPointsResponse.self)
            user.points = updateData.totalPoints
            
            try await user.save(on: req.db)

            return .ok
        }

    }
}
