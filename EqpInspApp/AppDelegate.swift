//
//  AppDelegate.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/07.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // サーバ設定
        // 【Swift】UserDefaultsの使い方
        // https://capibara1969.com/2531/
        let server:String
        if let _server = UserDefaults.standard.string(forKey: "settings.server") {
            print(_server)
            server = _server
        } else {
            server = "192.168.1.9"
        }
        
        // タイムアウト設定
        let timeoutInterval:TimeInterval
        if let _timeoutInterval = UserDefaults.standard.string(forKey: "settings.timeoutInterval") {
            print(_timeoutInterval)
            // How to convert a string to a double
            // https://www.hackingwithswift.com/example-code/language/how-to-convert-a-string-to-a-double
            timeoutInterval = (_timeoutInterval as NSString).doubleValue
        } else {
            timeoutInterval = 10
        }
        
        EqpInspSingleton.shared.settings.server = server
        EqpInspSingleton.shared.settings.timeoutInterval = timeoutInterval
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

