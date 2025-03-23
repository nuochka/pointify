import Vapor
import Fluent
import FluentPostgresDriver
import SwiftDotenv

public func configure(_ app: Application) async throws {
    try Dotenv.configure()

    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let port = Environment.get("DATABASE_PORT").flatMap { Int($0) } ?? 5432
    let username = Environment.get("DATABASE_USERNAME") ?? "your_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "your_password"
    let database = Environment.get("DATABASE_NAME") ?? "your_database_name"

    let config = SQLPostgresConfiguration(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database,
        tls: .prefer(try .init(configuration: .clientDefault))
    )

    app.databases.use(.postgres(configuration: config), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateGoal())
    app.migrations.add(CreateTask())

    try routes(app)
}
