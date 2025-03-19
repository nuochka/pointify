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
    @Published var isAuthenticated: Bool = false

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
                
                guard let data = data else {
                    self.message = "No data received"
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        if let userId = responseJSON?["id"] as? String {
                            UserDefaults.standard.set(userId, forKey: "userId")
                            self.isAuthenticated = true
                            self.message = "Login successful"
                        } else {
                            self.message = "User ID not found in response"
                        }
                    } catch {
                        self.message = "Failed to parse server response"
                    }
                } else {
                    self.message = "Invalid email or password."
                }
            }
        }.resume()
    }

}

