//
//  CreateGoal.swift
//  PointifyServer
//
//  Created by nuochka on 18/03/2025.
//

import Fluent

struct CreateGoal: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
         database.schema("goals")
            .id()
            .field("title", .string, .required)
            .field("is_completed", .bool, .required)
            .field("points", .int, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("goals").delete()
    }
}
