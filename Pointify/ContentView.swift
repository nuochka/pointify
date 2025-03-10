//
//  ContentView.swift
//  Pointify
//
//  Created by nuochka on 10/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 30){
                Spacer()
                
                Image("welcome_picture")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
                
                Text("Welcome to Pointify!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Track your points, stay motivated and achieve your goals!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5.0)
                
                Spacer()
                
                NavigationLink(destination: LoginView()){
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
