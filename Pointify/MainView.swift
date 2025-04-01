import SwiftUI

struct MainView: View {
    @State private var totalPoints: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Your Points: \(totalPoints)")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 40)
                
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

                Spacer()            }
            .padding()
        }
    }
}

#Preview {
    MainView()
}
