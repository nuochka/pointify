//
//  MainView.swift
//  Pointify
//
//  Created by nuochka on 17/03/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 30){
                Spacer()
                
                Text("Hello!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MainView()
}
