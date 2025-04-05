import Foundation

struct UserPointsResponse: Codable {
    let totalPoints: Int
}

class MainViewModel: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var isLoading: Bool = true
    private let userId: UUID
    private let baseURL = "http://localhost:8080/users"
    
    init(userId: UUID) {
        self.userId = userId
        fetchUserPoints()
    }
    
    func fetchUserPoints() {
        guard let url = URL(string: "\(baseURL)/\(userId)/points") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching user points:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            do {
                let pointsResponse = try JSONDecoder().decode(UserPointsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.totalPoints = pointsResponse.totalPoints
                    self.isLoading = false
                }
            } catch {
                print("Error decoding points:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userId")
    }
}
