//
//  LoginViewModel.swift
//  Pointify
//
//  Created by nuochka on 17/03/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var message: String = ""

    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            message = "Please enter email and password"
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/login") else {
            message = "Invalid URL"
            return
        }
        
        let jsonData = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData)
        } catch {
            message = "Failed to encode data"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "Request failed: \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.message = "No response"
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    self.message = "Login successful"
                } else {
                    self.message = "Login failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}

