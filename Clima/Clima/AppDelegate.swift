//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tohid Fahim on 18/6/20.
//  Copyright © 2020 Tohid Fahim. All rights reserved.
//


import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
            print(didAllow)
        }
        
        let object = WeatherViewController()
        
        let notiTemp = object.defaults.integer(forKey: "Notification")
        
        // - NOTIFICATION BOBY
        let content = UNMutableNotificationContent()
         content.title = "Weather Alert"
         content.subtitle = "Please Check Weather"
         content.body = "Your City Temparature is \(notiTemp) ℃"
         content.badge = 1
         
         // - FOR TRIGGER WITH TIME INTERVAI
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
         
         // - ADDING UPPER TWO FOR REQUEST
         let request = UNNotificationRequest(identifier: "Timer Done", content: content, trigger: trigger)
         
         // - COMPLETE THE TOTAL ACTION
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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

