//
//  Logger.swift
//  Minou
//
//  Created by Cédric CALISTI on 05/09/2023.
//

import OSLog


extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.i2cmedia.Minou"

    static let viewCycle = Logger(subsystem: subsystem, category: "View")

    static let catAPIManager = Logger(subsystem: subsystem, category: "CatAPIManager")

    static let coreData = Logger(subsystem: subsystem, category: "CoreDataStorage")

    static let cacheImages = Logger(subsystem: subsystem, category: "CacheImages")
}
