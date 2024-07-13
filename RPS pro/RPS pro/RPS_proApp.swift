//
//  RPS_proApp.swift
//  RPS pro
//
//  Created by Simon Plotkin on 6/20/24.
//

import SwiftUI

@main
struct RPS_proApp: App {
    @StateObject var model = CameraFeed()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
