//
//  SceneDelegate.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        let networkService = NetworkService()
        let downloadService = DownloadService()
        
        let viewController = UIViewController()
        navigationController.viewControllers = [viewController]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

