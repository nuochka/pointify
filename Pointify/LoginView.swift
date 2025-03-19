import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var isSecure = true
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            if !isLoggedIn {
                GoalsView()
            } else {
                VStack {
                    Spacer()
                    
                    Text("Sign in to Pointify")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    Text("Track your points and stay on top of your goals.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        if !viewModel.message.isEmpty {
                            Text(viewModel.message)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                        }
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email", text: $viewModel.email)
                                .disableAutocorrection(true)
                        }
                        .padding()
                        .background(Color.gray.brightness(0.4))
                        .cornerRadius(12)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            
                            if isSecure {
                                SecureField("Password", text: $viewModel.password)
                            } else {
                                TextField("Password", text: $viewModel.password)
                            }
                            
                            Button(action: {
                                isSecure.toggle()
                            }) {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.gray.brightness(0.4))
                        .cornerRadius(12)
                        
                        HStack {
                            NavigationLink(destination: ContentView()){
                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        Button(action: {
                            viewModel.loginUser()
                        }) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        HStack {
                            Text("Do not have an account yet?")
                                .foregroundColor(Color.gray)
                            NavigationLink(destination: RegisterView()) {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    .onReceive(viewModel.$isAuthenticated) { isAuth in
                        if isAuth {
                            isLoggedIn = true
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
