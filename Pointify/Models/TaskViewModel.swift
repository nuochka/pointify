//
//  TaskViewModel.swift
//  Pointify
//
//  Created by nuochka on 23/03/2025.
//

import Foundation

final class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var totalPoints: Int = 0
    
    private let baseURL = "http://localhost:8080/tasks"
    private let userId: UUID
    private let pointsURL = "http://localhost:8080/users"
    
    init(userId: UUID) {
        self.userId = userId
        fetchTasks()
        fetchTotalPoints()
    }
    
    func fetchTasks() {
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([Task].self, from: data) {
                    DispatchQueue.main.async {
                        self.tasks = decoded.filter { $0.userId == self.userId }
                    }
                }
            }
        }.resume()
    }
    
    func fetchTotalPoints() {
        guard let url = URL(string: "\(pointsURL)/\(userId)/points") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(UserPointsResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.totalPoints = decoded.totalPoints
                    }
                }
            }
        }.resume()
    }

    func addTask(title: String, points: Int, isCompleted: Bool) {
        guard let url = URL(string: baseURL) else { return }
        
        let isCompletedString = isCompleted ? "true" : "false"
        let pointsString = String(points)
        
        let body: [String: Any] = [
            "title": title,
            "isCompleted": isCompletedString,
            "points": pointsString,
            "user_id": userId.uuidString
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error adding task: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.fetchTasks()
            }
        }.resume()
    }
    
    func deleteTask(taskId: UUID) {
        guard let task = tasks.first(where: { $0.id == taskId }) else { return }
        
        let points = task.points
        
        guard let url = URL(string: "\(baseURL)/\(taskId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error deleting task")
                return
            }
            
            DispatchQueue.main.async {
                self.tasks.removeAll { $0.id == taskId }
                self.totalPoints -= points
                self.updateUserPoints()
            }
        }.resume()
    }

    func toggleTaskCompletion(taskId: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        
        let newStatus = !tasks[index].isCompleted
        let points = tasks[index].points
        
        if newStatus {
            self.totalPoints += points
            self.totalPoints -= points
        }
        
        guard let url = URL(string: "\(baseURL)/\(taskId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Bool] = ["isCompleted": newStatus]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating task: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.tasks[index].isCompleted = newStatus
            }
        }.resume()
        updateUserPoints()
    }

    func updateUserPoints() {
        guard let url = URL(string: "\(pointsURL)/\(userId)/points") else { return }
        
        let body: [String: Int] = ["totalPoints": totalPoints]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating user points: \(error.localizedDescription)")
            }
        }.resume()
    }
}
