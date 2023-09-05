//
//  MinouApp.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

@main
struct MinouApp: App {
    @StateObject var catAPIManager = CatAPIManager()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(catAPIManager)
        }
    }
}
