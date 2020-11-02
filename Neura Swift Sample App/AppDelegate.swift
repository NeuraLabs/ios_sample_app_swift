//
//  AppDelegate.swift
//  Push Notifications Test
//
//  Created by Neura on 7/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import UIKit
import NeuraSDK
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        /*The app UID and Secret were given to you at the end of the app registration process
        Change the values below to the ones related to your app (https://dev.theneura.com/console/apps)*/
        NeuraSDK.shared.setAppUID("[APP_ID]", appSecret: "[APP_SECRET]")
        
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
          appId: "YOUR_ONESIGNAL_APP_ID",
          handleNotificationAction: nil,
          settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
        
        
        
        
        PushNotifications.requestPermissionForPushNotifications()
        return true
    }
    
   //implement the following methods in order to maintain proper functionality of the Neura SDK and to support push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if NeuraSDKPushNotification.handleNeuraPush(withInfo: userInfo, fetchCompletionHandler: completionHandler) {
            // A remote notificiation, sent from Neura's server was handled by Neura's SDK.
            // The SDK will call the completion handler.
            return
        }
        
        // Handle here your own remote notifications.
        // It is your responsibility to call the completionHandler.
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotifications.register(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog(">>> Error with registering for remote notifications: \(error)")
        NSLog("Please check that you set everything right for supporting push notifications on iOS dev center")

    }
    // allowa OS minimal time in background from time to time
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //This will allow NeuraSDK to initiate data collection as a background fetch of your app
        NeuraSDK.shared.collectDataForBGFetch { result in
            completionHandler(result)
        }
    }
}
