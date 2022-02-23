import UIKit
import Core
import Trending

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let coreAssembly = Core.Assembly()
        let trendingAssembly = Trending.Assembly(coreAssembly: coreAssembly)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = trendingAssembly.viewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
