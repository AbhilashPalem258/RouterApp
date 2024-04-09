//
//  File.swift
//  
//
//  Created by Abhilash Palem on 09/04/24.
//

import Foundation
import OSLog

func logError(_ message: String) {
    Logger.RouterModule.error("\(message)")
}

extension Logger {
    private static let subsystem = "com.abhilash.iOS.Router"
    static let RouterModule = Logger(subsystem: subsystem, category: "RouterModule")
}
