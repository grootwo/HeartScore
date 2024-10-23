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
        if gamecentermanager.authenticateUser() {
            HeartView()
        }
    }
}

#Preview {
    ContentView()
}
