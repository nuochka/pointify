import Foundation

class RegisterViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var message: String = ""
    
    func registerUser() {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            message = "Please fill in all fields."
            return
        }
        
        if name.count < 2 {
            message = "Name should be at least 2 characters long."
            return
        }
        
        if !email.contains("@") {
            message = "Invalid email format."
            return
        }
        
        if password.count < 6 {
            message = "Password should be at least 6 characters long."
            return
        }
        
        if !isPasswordStrong(password) {
            message = "Password must contain uppercase letters, lowercase letters, digits, and special characters."
            return
        }
        
        if password != confirmPassword {
            message = "Passwords do not match."
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/register") else {
            message = "Invalid URL"
            return
        }
        
        let jsonData = [
            "name": name,
            "email": email,
            "password": password
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData)
        } catch {
            message = "Error encoding data"
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.message = "Request failed: \(error.localizedDescription)"
                }
                return
            }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let emailResponse = json["email"] as? String {
                        UserDefaults.standard.set(emailResponse, forKey: "email")
                        
                        DispatchQueue.main.async {
                            self.message = "Registration successful!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.message = "Failed to get email from server."
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.message = "Error parsing response from server."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.message = "Registration failed."
                }
            }
        }
        task.resume()
    }
    
    func isPasswordStrong(_ password: String) -> Bool {
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+{}:;,.?/~]).{6,}"
            
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }

    func getUserId() -> UUID? {
        if let emailString = UserDefaults.standard.string(forKey: "email") {
            return UUID(uuidString: emailString)
        }
        return nil
    }
}
