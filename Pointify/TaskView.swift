import SwiftUI

struct TaskView: View {
    @StateObject var viewModel: TaskViewModel
    @State private var newTitle: String = ""
    @State private var newPoints: String = ""
    @State private var isCompleted: Bool = false
    
    init() {
        if let userIdString = UserDefaults.standard.string(forKey: "userId"),
           let userId = UUID(uuidString: userIdString) {
            _viewModel = StateObject(wrappedValue: TaskViewModel(userId: userId))
        } else {
            let newId = UUID()
            UserDefaults.standard.set(newId.uuidString, forKey: "userId")
            _viewModel = StateObject(wrappedValue: TaskViewModel(userId: newId))
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Add your tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                Text("Manage your tasks and earn points by completing them")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()

                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                        TextField("Task", text: $newTitle)
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
                            viewModel.addTask(title: newTitle, points: points, isCompleted: isCompleted)
                            newTitle = ""
                            newPoints = ""
                            isCompleted = false
                        }
                    }) {
                        Text("Add Task")
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
                    Section(header: Text("Your Tasks")) {
                        if viewModel.tasks.isEmpty {
                            Text("No tasks yet.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.tasks) { task in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                            .font(.headline)
                                        Text("\(task.points) points")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Button(action: {
                                        viewModel.toggleTaskCompletion(taskId: task.id)
                                    }) {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(task.isCompleted ? .green : .gray)
                                    }
                                    Button(action: {
                                        viewModel.deleteTask(taskId: task.id)
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
        TaskView()
    }
}
