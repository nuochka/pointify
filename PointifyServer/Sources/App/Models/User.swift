//
//  User.swift
//  PointifyServer
//
//  Created by nuochka on 15/03/2025.
//


import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "points")
    var points: Int
    
    init() {}
    
    init(id: UUID? = nil, name: String, email: String, password: String, points: Int = 0){
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.points = points
    }
    
}
extension User {
    struct Public: Content {
        var id: UUID
        var email: String
    }

    func asPublic() throws -> Public {
        return Public(id: try requireID(), email: self.email)
    }
}

