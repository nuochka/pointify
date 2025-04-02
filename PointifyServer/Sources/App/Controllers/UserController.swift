import Vapor
import Fluent

struct UserPointsResponse: Content {
    let totalPoints: Int
}

final class UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.get(":userId", "points") { req async throws -> UserPointsResponse in
            guard let userId = req.parameters.get("userId", as: UUID.self) else {
                throw Abort(.badRequest, reason: "Invalid user ID")
            }

            print("Fetching points for user with ID: \(userId)")

            let tasks = try await Task.query(on: req.db)
                .filter(\.$userId == userId)
                .filter(\.$isCompleted == true)
                .all()

            print("Found \(tasks.count) completed tasks for user \(userId)")

            let totalPoints = tasks.reduce(0) { $0 + $1.points }

            print("Total points for user \(userId): \(totalPoints)")

            return UserPointsResponse(totalPoints: totalPoints)
        }

    }
}
