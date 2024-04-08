//
//  SceneDelegate.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import DeepLink
import Router

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainRouter: (any Routing)?
    private let deepLinkCoordinator = DeeplinkCoordinator(handlers: [
        OnboardingDeepLinkHandler.self
    ])
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let scene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: scene)
            do {
                mainRouter = try window.mainRouter()
                try mainRouter?.setRoot("FirstAppIntro")
            } catch {
                debugPrint("Failed to get main router")
            }
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
        
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let incomingURL = URLContexts.first?.url, let mainRouter else {
            return
        }
        deepLinkCoordinator.handleURL(incomingURL, router: mainRouter)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // Get URL components from the incoming user activity.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL, let mainRouter else {
            return
        }
        deepLinkCoordinator.handleURL(incomingURL, router: mainRouter)
    }
}
