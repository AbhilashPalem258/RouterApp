//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation
import Router

// influenced from https://blogs.halodoc.io/deep-linking-using-url-scheme-in-ios/

protocol DeeplinkCoordinatorProtocol {
    @discardableResult
    func handleURL(_ url: URL, router: some Routing) -> Bool
}

public final class DeeplinkCoordinator {
    
    let handlers: [any DeepLinkHandling.Type]
    
    public init(handlers: [any DeepLinkHandling.Type]) {
        self.handlers = handlers
    }
}

extension DeeplinkCoordinator: DeeplinkCoordinatorProtocol {
    @discardableResult
    public func handleURL(_ url: URL, router: some Routing) -> Bool {
        guard let handler = handlers.first(where: { $0.canOpenURL(url) }) else {
            return false
        }
              
        handler.openURL(url, router: router)
        return true
    }
}
