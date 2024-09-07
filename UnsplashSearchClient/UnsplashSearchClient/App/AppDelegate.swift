//
//  AppDelegate.swift
//  UnsplashSearchClient
//
//  Created by Анна Вертикова on 07.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_: UIApplication,
                     handleEventsForBackgroundURLSession _: String,
                     completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
