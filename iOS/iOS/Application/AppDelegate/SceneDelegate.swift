//
//  SceneDelegate.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainRouter: Router?
    private let deeplinkHandler = DeepLinkHandler()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let scene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: scene)
            mainRouter = window.mainRouter()
            mainRouter?.setRoot("FirstAppIntro")
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
    
//    func scene(_ scene: UIScene, willConnectTo
//               session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//        
//    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let incomingURL = URLContexts.first?.url, let mainRouter else {
            return
        }

        deeplinkHandler.handle(incomingURL: incomingURL, router: mainRouter)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // Get URL components from the incoming user activity.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL, let mainRouter else {
            return
        }
        deeplinkHandler.handle(incomingURL: incomingURL, router: mainRouter)
    }
}
