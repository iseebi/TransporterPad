//
//  Environment.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/15.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class Environment: NSObject {

    let userSettings: UserSettings

    let embeddedIosDeployToolPath: String
    let embeddedAdbToolPath: String
    
    var iosDeployToolPath: String {
        get {
            return userSettings.iosDeployToolPath ?? embeddedIosDeployToolPath
        }
    }

    var adbToolPath: String {
        get {
            return userSettings.adbToolPath ?? embeddedAdbToolPath
        }
    }

    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        let resourceURL = Bundle.main.resourceURL!
        embeddedIosDeployToolPath = resourceURL
                .appendingPathComponent("ios-deploy")
                .appendingPathComponent("ios-deploy")
                .path
        embeddedAdbToolPath = resourceURL
                .appendingPathComponent("android-platform-tools")
                .appendingPathComponent("adb")
                .path
    }
}
