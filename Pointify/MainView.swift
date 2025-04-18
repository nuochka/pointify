import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel: MainViewModel
    @AppStorage("userId") private var userIdString: String?
    @State private var isLoggedIn: Bool = true
    
    init() {
        if let userIdString = UserDefaults.standard.string(forKey: "userId"),
           let userId = UUID(uuidString: userIdString) {
            _mainViewModel = StateObject(wrappedValue: MainViewModel(userId: userId))
        } else {
            let newId = UUID()
            UserDefaults.standard.set(newId.uuidString, forKey: "userId")
            _mainViewModel = StateObject(wrappedValue: MainViewModel(userId: newId))
        }
    }

    var body: some View {
        VStack {
            if isLoggedIn {
                NavigationStack {
                    ZStack {
                        VStack(spacing: 25) {
                            Spacer()

                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.1))
                                    .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 5)

                                VStack {
                                    Text("Your Points")
                                        .font(.headline)
                                        .foregroundColor(.black.opacity(0.6))
                                    Text("\(mainViewModel.totalPoints)")
                                        .font(.system(size: 50, weight: .bold, design: .rounded))
                                        .foregroundColor(.black)
                                }
                                .padding()
                            }
                            .frame(width: 250, height: 120)

                            VStack(spacing: 15) {
                                NavigationLink(destination: TaskView()) {
                                    CustomButton(title: "Create Task")
                                }

                                NavigationLink(destination: GoalsView()) {
                                    CustomButton(title: "Create Goal")
                                }
                            }
                            .padding(.horizontal)

                            Spacer()
                        }
                        .padding()
                        .onAppear {
                            mainViewModel.fetchUserPoints()
                        }
                    }
                    .toolbar {
                        Button("Logout") {
                            logoutUser()
                        }
                    }
                }
            } else {
                LoginView()
            }
        }
    }

    private func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "userId")
        userIdString = nil
        isLoggedIn = false
    }
}

struct CustomButton: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.3), radius: 5)
    }
}

#Preview {
    MainView()
}
