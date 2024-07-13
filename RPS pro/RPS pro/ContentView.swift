//
//  ContentView.swift
//  RPS pro
//
//  Created by Simon Plotkin on 6/20/24.
//

import SwiftUI

// Main menu
struct ContentView: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                Image("rps")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius:30)
                    .padding()
                
                Text("Rock, Paper, Scissors!")
                    .multilineTextAlignment(.center)
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                // Sends the player to the instructions screen
                NavigationLink {
                    instructions()
                } label: {
                    Text("Start the game")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                
                
                Spacer()
                
                Text("Produced by Simon Plotkin")
                    .fontWeight(.ultraLight)
                    .font(.caption)
                    
            }
            
        }
        
    }

}

struct instructions: View {
    @EnvironmentObject var model : CameraFeed
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            
            
            Spacer()
            
            // Start the game button
            NavigationLink {
                DisplayView(image: model.frame)
            } label: {
                Text("I'm ready!!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
            
            
            // Go back button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Go back!!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .toolbar(.hidden)
        
    }
}

#Preview {
    ContentView()
}
