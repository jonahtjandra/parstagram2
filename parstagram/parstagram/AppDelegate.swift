//
//  AppDelegate.swift
//  parstagram
//
//  Created by Jonah Tjandra on 3/25/22.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "vPi63LsHSelvOaAq1Vl2OmYqTVIk2OXztQBUB3J5"
                $0.clientKey = "fvhfipWjEQg3UljRRzPAuRRBevN9BUhQ32ebboBv"
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        return true
    }

}

