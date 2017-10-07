//
//  UserSettings.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/15.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

class UserSettings: NSObject {

    let userDefaults: UserDefaults = UserDefaults.standard

    var iosDeployToolPath: String? {
        get {
            return userDefaults.string(forKey: "iosDeployToolPath")
        }
        set(value) {
            userDefaults.set(value, forKey: "iosDeployToolPath")
        }
    }

    var adbToolPath: String? {
        get {
            return userDefaults.string(forKey: "adbToolPath")
        }
        set(value) {
            userDefaults.set(value, forKey: "adbToolPath")
        }
    }
}
