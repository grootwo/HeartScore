//
//  HeartView.swift
//  HeartScore
//
//  Created by Groo on 10/23/24.
//

import SwiftUI

struct HeartView: View {
    @State private var heartCount: Int = 0
    let gameCenterManager = GameCenterManager()
    var body: some View {
        VStack(spacing: 30) {
            Button(action: {
                gameCenterManager.showAchievements()
            }, label: {
                Image(systemName: "gamecontroller.fill")
                    .font(.largeTitle)
            })
            .tint(.red)
            .buttonStyle(.bordered)
            Spacer()            Button(action: {
                heartCount += 1
                Task {
                    await gameCenterManager.submitPoint(point: 1)
                }
            }, label: {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(RadialGradient(gradient: Gradient(colors: [.red, .pink]), center: .center, startRadius: 50, endRadius: 100))
            })
            Spacer()
            Text("Your Heart Score: \(heartCount)")
                .font(.largeTitle)
        }
        .padding()
    }
}

#Preview {
    HeartView()
}
