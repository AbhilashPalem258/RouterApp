//
//  DeepLinkHandler.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation
import DeepLink
import Router

enum OnboardingDeepLinkHandler: DeepLinkHandling {
    
    private static var flow: String {
        "OnboardingFlow"
    }
    
    static func canOpenURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        return components.path.contains(flow)
    }
    
    static func openURL(_ url: URL, router: some Routing) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }


        // Check for specific URL components that you need.
        let path = components.path
        var params = components.queryItems?.reduce(into: [String: Any](), { partialResult, queryItem in
            partialResult[queryItem.name] = queryItem.value
        })
        let scheme = components.scheme
        let host = components.host
        
        
        debugPrint("""
            ************************
            scheme = \(String(describing: scheme))
            host = \(String(describing: host))
            path = \(path)
            params = \(String(describing: params))
            ***********************
        """)
        
        guard let id = params?["id"] as? String else {
            return
        }
        params?["id"] = nil
        router.dismissChild { parent in
            do {
                try router.present(id, params: params, completion: nil)
            } catch {
                logError("Failed to navigate to \(id) error: \(error)")
            }
        }
    }
}
