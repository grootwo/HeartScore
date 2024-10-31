//
//  ContentView.swift
//  HeartScore
//
//  Created by Groo on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    let gamecentermanager = GameCenterManager()
    var body: some View {
        HeartView()
        .onAppear {
            gamecentermanager.authenticateUser()
        }
    }
}

#Preview {
    ContentView()
}
