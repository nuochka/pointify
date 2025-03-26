import SwiftUI

struct GoalsView: View {
    @StateObject var viewModel: GoalViewModel
    @State private var newTitle: String = ""
    @State private var newPoints: String = ""
    @State private var isCompleted: Bool = false
    
    init() {
        if let userIdString = UserDefaults.standard.string(forKey: "userId"),
           let userId = UUID(uuidString: userIdString) {
            _viewModel = StateObject(wrappedValue: GoalViewModel(userId: userId))
        } else {
            let newId = UUID()
            UserDefaults.standard.set(newId.uuidString, forKey: "userId")
            _viewModel = StateObject(wrappedValue: GoalViewModel(userId: newId))
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Create your goal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                Text("Add and track your goals to earn points.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()

                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                        TextField("Goal", text: $newTitle)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color.gray.brightness(0.4))
                    .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                        TextField("Points", text: $newPoints)
                            //.keyboardType(.numberPad)
                    }
                    .padding()
                    .background(Color.gray.brightness(0.4))
                    .cornerRadius(12)
                    
                    Button(action: {
                        if let points = Int(newPoints), !newTitle.isEmpty {
                            viewModel.addGoal(title: newTitle, points: points, isCompleted: isCompleted)
                            newTitle = ""
                            newPoints = ""
                            isCompleted = false
                        }
                    }) {
                        Text("Add Goal")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(newTitle.isEmpty || Int(newPoints) == nil)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    Section(header: Text("Your Goals")) {
                        if viewModel.goals.isEmpty {
                            Text("No goals yet.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.goals) { goal in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(goal.title)
                                            .font(.headline)
                                        Text("\(goal.points) points")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(goal.isCompleted ? .green : .gray)
                                    Button(action: {
                                        viewModel.deleteGoal(goalId: goal.id)
                                    }){
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
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
    NavigationStack {
        GoalsView()
    }
}
