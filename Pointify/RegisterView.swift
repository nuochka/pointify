//
//  RegisterView.swift
//  Pointify
//
//  Created by nuochka on 12/03/2025.
//


import SwiftUI

struct RegisterView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSecure: Bool = true
    @State private var isSecureConfirm: Bool = true
    
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
                    TextField("Name", text: $name)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.brightness(0.4))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.brightness(0.4))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    if isSecure {
                        SecureField("Password", text: $password)
                    } else {
                        TextField("Password", text: $password)
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
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    if isSecureConfirm {
                        SecureField("Confirm Password", text: $confirmPassword)
                    } else {
                        TextField("Confirm Password", text: $confirmPassword)
                    }
                    Button(action: {
                        isSecureConfirm.toggle()
                    }) {
                        Image(systemName: isSecureConfirm ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.brightness(0.4))
                .cornerRadius(12)
                
                Button(action: {
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
