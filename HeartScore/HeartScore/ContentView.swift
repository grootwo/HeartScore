//
//  ContentView.swift
//  HeartScore
//
//  Created by Groo on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var heartCount: Int = 0
    var body: some View {
        VStack(spacing: 30) {
            Button(action: {
                heartCount += 1
            }, label: {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(RadialGradient(gradient: Gradient(colors: [.red, .pink]), center: .center, startRadius: 50, endRadius: 100))
            })
            Text("Your Heart Score: \(heartCount)")
                .font(.largeTitle)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
