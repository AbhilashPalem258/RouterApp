//
//  Logger+Extensions.swift
//  iOS
//
//  Created by Abhilash Palem on 09/04/24.
//

import Foundation
import OSLog

func logError(_ message: String) {
    Logger.Router.error("\(message)")
}

func logInfo(_ message: String) {
    Logger.Router.info("\(message)")
}

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.abhilash.iOS"
    static let Router = Logger(subsystem: subsystem, category: "Router")
}
