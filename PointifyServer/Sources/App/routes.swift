import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: RegisterController())
    try app.register(collection: LoginController())
    try app.register(collection: GoalController())
    try app.register(collection: TaskController())
    try app.register(collection: UserController())
}
