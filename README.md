# How to use?

## Screen Coordinator Setup

Import the package

```swift
import Router
```

Confirm the screen coordinator to `RoutableCoordinator` protocol

```swift
final class SomeScreenCoordinator: RoutableCoordinator 
```
The `RoutableCoordinator` protocol provides us with an initializer where we get the `Routing` instance which should be assigned to a local variable so that we can use the router for navigating to other screens

```
init(router: some Routing, context: RoutingContext) {
    self.router = router
}
```
Use the router api's whenever we need to navigate to other screens

```
do {
    try router.push("BiometricAuthLogin")
} catch {
    logError("Failed to navigate to \(NavigationKeys.glassBGLogin.rawValue) error: \(error)")
}
```

## Routing protocol

Here are all the Routing api's which we can use for screen navigation

```
public protocol Routing: AnyObject {
    func setRoot(_ id: String, params: [String: Any]?) throws
    func push(_ id: String, params: [String: Any]?) throws
    func pop(animated: Bool)
    func present(_ id: String, params: [String: Any]?, completion: ((any Routing) -> Void)?) throws
    func dismiss(completion: ((any Routing) -> Void)?)
    func dismissChild(completion: ((any Routing) -> Void)?)
    
    func setRoot(_ id: String) throws
    func push(_ id: String) throws
    func present(_ id: String, completion: ((any Routing) -> Void)?) throws
}
```

## MainRouter
MainRouter is used to set the initial root view controller of key window and for handling the deeplink url's navigation. We can fetch and use main router in AppDelegate's didFinishLaunching method or SceneDelegate's scene:WillConnectTo: method

```
var mainRouter: (any Routing)?
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
```

# DeepLink Setup

import the DeepLink Module of Router package whereever our app first interacts with deeplink urls like AppDelegate / SceneDelegate / App 
Then create an instance of `DeeplinkCoordinator` by passing all the handlers `DeepLinkHandling` protocol

```
private let deepLinkCoordinator = DeeplinkCoordinator(handlers: [
    OnboardingDeepLinkHandler.self
])
```

Use DeeplinkCoordinator's handleURL to handoff the deep link handling

```
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let incomingURL = URLContexts.first?.url, let mainRouter else {
        return
    }
    deepLinkCoordinator.handleURL(incomingURL, router: mainRouter)
}
```

we get mainRouter from UIWindow's mainRouter() method from Router package

```
do {
    mainRouter = try window.mainRouter()
    try mainRouter?.setRoot("FirstAppIntro")
} catch {
    debugPrint("Failed to get main router")
}
```

### DeepLinkHandler usage

import the DeepLink and Router Module of Router package

```
import DeepLink
import Router

enum OnboardingDeepLinkHandler: DeepLinkHandling {
    static func canOpenURL(_ url: URL) -> Bool {
        /...
    }

    static func openURL(_ url: URL, router: some Routing) {
        /...
        router.dismissChild { parent in
            do {
                try router.present(id, params: params, completion: nil)
            } catch {
                logError("Failed to navigate to \(id) error: \(error)")
            }
        }
    }
}
```


## Router
Router is like a convenience navigation controller wrapper which confoms to `Routing` protocol. `Router` type is not exposed to the host app. Host can use `Routing` protocol instance to communicate with `Router`
