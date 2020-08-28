//
//  AppDelegate.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/4/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import UserNotifications
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var restrictRotation:UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_51GvbBAEPbWJjd5AT4ikoZcPtHbOg26QJG9CXU10ajmPwFKUW0bdkCmZNDNNpBjfzlaAuY1KdJjdFcvkbjCUlhFbq009jHYILSb"
        //Stripe.setDefaultPublishableKey("pk_test_51GvbBAEPbWJjd5AT4ikoZcPtHbOg26QJG9CXU10ajmPwFKUW0bdkCmZNDNNpBjfzlaAuY1KdJjdFcvkbjCUlhFbq009jHYILSb")
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        //window?.rootViewController = MainTabVC()
        
        let navController = UINavigationController(rootViewController: MainTabVC())
        window?.rootViewController = navController
        navController.navigationBar.isHidden = true
        
   
        /*
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabVC()
        */
        
        // implemented for region identification.
        // self.locationManager = CLLocationManager()
        // self.locationManager!.delegate = self
        
        // Override point for customization after application launch.
        
        attemptToRegisterForNotifications(application: application)
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
    
    func attemptToRegisterForNotifications(application: UIApplication) {
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (authorized, error) in
            if authorized {
                print("DEBUG: SUCCESSFULLY REGISTERED FOR NOTIFICATIONS")
            }
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEBUG: Registered for notifications with device token: ", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("DEBUG: Registered with FCM Token: ", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        CoreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CoreDataStack.saveContext()
    }
    
    // Below delegate class function that can be used if I want to return back to the main screen.
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

