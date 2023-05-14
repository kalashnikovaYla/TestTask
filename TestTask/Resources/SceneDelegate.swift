//
//  SceneDelegate.swift
//  TestTask
//
//  Created by sss on 12.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let gridVC = GridViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: gridVC)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .clear
    }

}

