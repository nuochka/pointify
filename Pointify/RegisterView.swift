//
//  RegisterView.swift
//  Pointify
//
//  Created by nuochka on 12/03/2025.
//


import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Create your account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text("Join Pointify and start tracking your progress.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 20) {
                
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Name", text: $viewModel.name)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.brightness(0.4))
                .cornerRadius(12)
                
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
                    SecureField("Password", text: $viewModel.password)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.brightness(0.4))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.brightness(0.4))
                .cornerRadius(12)
                
                Button(action: {
                    viewModel.registerUser()
                }) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
                
                if !viewModel.message.isEmpty {
                    Text(viewModel.message)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: LoginView()) {
                        Text("Sign in")
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}

