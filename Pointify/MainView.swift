import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel: MainViewModel

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
        NavigationStack {
            VStack(spacing: 30) {
                if mainViewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Text("Your Points: \(mainViewModel.totalPoints)")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 40)
                }
                
                HStack(spacing: 20) {
                    NavigationLink(destination: TaskView()) {
                        Text("Create task")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: GoalsView()) {
                        Text("Create goal")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MainView()
}
