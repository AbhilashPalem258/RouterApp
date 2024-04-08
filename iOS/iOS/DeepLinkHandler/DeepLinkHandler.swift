//
//  DeepLinkHandler.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation

protocol DeepLinkHandling {
    func handle(incomingURL: URL, router: Router)
}

struct DeepLinkHandler: DeepLinkHandling {
    func handle(incomingURL: URL, router: Router) {
        guard let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return
        }


        // Check for specific URL components that you need.
        let path = components.path
        var params = components.queryItems?.reduce(into: [String: String](), { partialResult, queryItem in
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
            router.present(id, params: params)
        }
    }
}
