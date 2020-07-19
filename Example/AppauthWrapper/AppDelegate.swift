//
//  AppDelegate.swift
//  AppauthWrapper
//
//  Created by Somendra Yadav on 06/07/20.
//  Copyright © 2020 Somendra Yadav. All rights reserved.
//

import UIKit
import AppAuth
import AppauthWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var app: AppAuth?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.app = AppAuth(clientID, clientSecret, redirectURI, authorization_scope, registration_endpoint_uri, user_info_endpoint_uri, issuer, authorizationEndpoint, tokenEndpoint, endSessionPointsURL)
        return true
    }
    
    func application(_ app: UIApplication,
                        open url: URL,
                        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           // Sends the URL to the current authorization flow (if any) which will
           // process it if it relates to an authorization response.
           if let authorizationFlow = self.currentAuthorizationFlow,
               authorizationFlow.resumeExternalUserAgentFlow(with: url) {
               self.currentAuthorizationFlow = nil
               return true
           }
        // Your additional URL handling (if any)
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

