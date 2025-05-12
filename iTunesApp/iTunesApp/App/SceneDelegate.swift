//
//  SceneDelegate.swift
//  iTunesApp
//
//  Created by 박주성 on 5/8/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let diContainer = DIContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = diContainer.makeHomeViewController()
        window?.makeKeyAndVisible()
    }
}
