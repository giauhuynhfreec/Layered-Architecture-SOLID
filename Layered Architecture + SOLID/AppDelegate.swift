//
//  AppDelegate.swift
//  Layered Architecture + SOLID
//
//  Created by Giau Huynh on 26/10/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var container: AppContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
#if DEBUG
        container = AppContainer(simulateNetworkFailure: false) // đổi true để test offline
#else
        container = AppContainer(simulateNetworkFailure: false)
#endif
        
        let win = UIWindow(frame: UIScreen.main.bounds)
        let root = ArticleListViewController(useCase: container.getArticlesUseCase,
                                             detailUseCase: container.getArticleDetailUseCase)
        let nav = UINavigationController(rootViewController: root)
        win.rootViewController = nav
        win.makeKeyAndVisible()
        window = win
        return true
    }

}
