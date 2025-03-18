//
//  Goal.swift
//  PointifyServer
//
//  Created by nuochka on 18/03/2025.
//

import Vapor
import Fluent

final class Goal: Model, Content {
    static let schema = "goals"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "is_completed")
    var isCompleted: Bool

    @Field(key: "points")
    var points: Int

    @Field(key: "user_id")
    var userId: UUID

    init() {}

    init(id: UUID? = nil, title: String, isCompleted: Bool = false, points: Int, userId: UUID) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.points = points
        self.userId = userId
    }
}
