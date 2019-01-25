//
//  NotificationManager.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/9/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
    
    override init(){
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    func completed() {
        let notification = NSUserNotification()
        notification.title = "TransporterPad"
        notification.subtitle = "Transport completed"
        notification.userInfo = ["key" : "completed"]
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let userInfo = notification.userInfo,
            let key = userInfo["key"] as? String
            else { return }
        
        if (key == "completed") {
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
}
