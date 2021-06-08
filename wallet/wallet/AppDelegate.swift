//
//  AppDelegate.swift
//  wallet
//
//  Created by Francisco Gindre on 12/26/19.
//  Copyright © 2019 Francisco Gindre. All rights reserved.
//

import UIKit
import BackgroundTasks
import zealous_logger

let tracker = NullLogger()
let logger = SimpleFileLogger(logsDirectory: try! URL.logsDirectory(), alsoPrint: true, level: .debug)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if targetEnvironment(simulator)
        if ProcessInfo.processInfo.environment["isTest"] != nil {
            return true
        }
        #endif
        // Override point for customization after application launch.
      
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskSyncronizing.backgroundAppRefreshTaskIdentifier,
          using: nil) { (task) in
            
            BackgroundTaskSyncronizing.default.handleBackgroundAppRefreshTask(task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskSyncronizing.backgroundProcessingTaskIdentifier,
          using: nil) { (task) in
            BackgroundTaskSyncronizing.default.handleBackgroundProcessingTask(task as! BGProcessingTask)
        }
        
        
        let environment = ZECCWalletEnvironment.shared
        switch environment.state {
        case .initalized,
             .synced:
            try! environment.initialize()
        default:
            break
        }
        
        UserDefaults.standard.register(defaults: [
            UserSettings.Keys.aPassCode: ""])
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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
