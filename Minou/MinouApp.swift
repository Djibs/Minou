//
//  MinouApp.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import SwiftUI

@main
struct MinouApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
