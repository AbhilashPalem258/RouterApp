//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation
import Router

public protocol DeepLinkHandling {
    static func canOpenURL(_ url: URL) -> Bool
    static func openURL(_ url: URL, router: some Routing)
}
