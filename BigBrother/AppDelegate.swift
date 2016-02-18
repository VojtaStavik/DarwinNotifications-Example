//
//  AppDelegate.swift
//  BigBrother
//
//  Created by Vojta Stavik on 18/02/16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit
import CCHDarwinNotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: []))
        CCHDarwinNotificationCenter.startForwardingDarwinNotificationsWithIdentifier("com.apple.springboard.pluggedin")
        CCHDarwinNotificationCenter.startForwardingDarwinNotificationsWithIdentifier("com.apple.springboard.lockcomplete")
        CCHDarwinNotificationCenter.startForwardingDarwinNotificationsWithIdentifier("com.apple.springboard.ringerstate")
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        setupNotifications()
    }
    
    var observers = [NSObjectProtocol]()
    
    func setupNotifications() {
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { [weak self] () -> Void in
            self?.observers.forEach { NSNotificationCenter.defaultCenter().removeObserver($0, name: nil, object: nil) }
        }
        
        let observer1 = NSNotificationCenter.defaultCenter().addObserverForName("com.apple.springboard.pluggedin", object: nil, queue: nil) { _ -> Void in
            let notification = UILocalNotification()
            notification.fireDate = NSDate().dateByAddingTimeInterval(0.1)
            notification.alertBody = "Cable Plugged in!"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        let observer2 = NSNotificationCenter.defaultCenter().addObserverForName("com.apple.springboard.lockcomplete", object: nil, queue: nil) { _ -> Void in
            let notification = UILocalNotification()
            notification.fireDate = NSDate().dateByAddingTimeInterval(1)
            notification.alertBody = "Locked!"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        let observer3 = NSNotificationCenter.defaultCenter().addObserverForName("com.apple.springboard.ringerstate", object: nil, queue: nil) { _ -> Void in
            let notification = UILocalNotification()
            notification.fireDate = NSDate().dateByAddingTimeInterval(0.1)
            notification.alertBody = "Ringer state changed!"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        observers = [observer1, observer2, observer3]
    }
}
