//
//  PushNotifications.swift
//  Neura Swift Sample App
//
//  Created by Neura on 08/08/2017.
//  Copyright © 2017 beauNeura. All rights reserved.
//
import UIKit
import NeuraSDK
import UserNotifications

let kStoredDeviceToken = "stored device token"

class PushNotifications: NSObject {
    
    class func requestPermissionForPushNotifications() {
        let app = UIApplication.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
        }
        
        app.registerForRemoteNotifications()
    }
    
    class func register(deviceToken: Data) {
        UserDefaults.standard.set(deviceToken, forKey: kStoredDeviceToken)
        /**
         Informs Neura's server about the push token.
         Also stores locally the token as string (use getDeviceToken to get the stored value).
         You must call this in application:didRegisterForRemoteNotificationsWithDeviceToken: for Neura's data collection to work as designed.
         */
        NeuraSDKPushNotification.registerDeviceToken(deviceToken)
    }
    
    class func storedDeviceToken() -> Data? {
        let deviceToken = UserDefaults.standard.value(forKey: kStoredDeviceToken) as? Data
        return deviceToken;
    }
}
