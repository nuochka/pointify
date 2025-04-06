//
//  TaskViewModel.swift
//  Pointify
//
//  Created by nuochka on 23/03/2025.
//

import Foundation

final class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let baseURL = "http://localhost:8080/tasks"
    private let userId: UUID
    
    init(userId: UUID) {
        self.userId = userId
        fetchTasks()
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
    
    func addTask(title: String, points: Int, isCompleted: Bool) {
        guard let url = URL(string: baseURL) else { return }
        
        guard let userIdString = UserDefaults.standard.string(forKey: "userId") else {
            print("User is not logged in.")
            return
        }
        let isCompletedString = isCompleted ? "true" : "false"
        let pointsString = String(points)
        
        let body: [String: Any] = [
            "title": title,
            "isCompleted": isCompletedString,
            "points": pointsString,
            "user_id": userIdString
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error adding goal: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server error: \(httpResponse.statusCode)")
                return
            }
            
            DispatchQueue.main.async {
                self.fetchTasks()
            }
        }.resume()
    }
    
    func deleteTask(taskId: UUID) {
        guard let url = URL(string: "\(baseURL)/\(taskId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error deleting goal")
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server error: \(httpResponse.statusCode)")
                return
            }
            
            DispatchQueue.main.async {
                self.tasks.removeAll { $0.id == taskId }
            }
        }.resume()
    }
    
    func toggleTaskCompletion(taskId: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        
        let newStatus = !tasks[index].isCompleted
        guard let url = URL(string: "\(baseURL)/\(taskId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Bool] = ["isCompleted": newStatus]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating goal: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.tasks[index].isCompleted = newStatus
                }
            }
        }.resume()
    }
}
