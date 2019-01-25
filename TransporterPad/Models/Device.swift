//
//  Device.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/18.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Foundation
import EBIMobileDeviceWatcher

@objcMembers class Device: NSObject {

    /// プラットフォーム
    let platform: Platform
    
    let formfactorName: String

    /// 端末名
    var name: String {
        willSet {
            self.willChangeValue(forKey: "name")
        }
        didSet {
            self.didChangeValue(forKey: "name")
        }
    }

    /// シリアルナンバー
    let serialNumber: String

    /// 端末の認識状態
    var status: DeviceStatus = .Initializing {
        willSet {
            self.willChangeValue(forKey: "status")
        }
        didSet {
            self.didChangeValue(forKey: "status")
        }
    }
    
    /// 互換性あり状態か
    var compatible: Bool = false {
        willSet {
            self.willChangeValue(forKey: "compatible")
        }
        didSet {
            self.didChangeValue(forKey: "compatible")
        }
    }

    /// 最終の転送ログ
    var log: String = "" {
        willSet {
            self.willChangeValue(forKey: "log")
        }
        didSet {
            self.didChangeValue(forKey: "log")
        }
    }

    /// 対応するモバイルデバイスインスタンス
    weak var mobileDevice: EBIMobileDevice?
    
    init(device: EBIMobileDevice) {
        mobileDevice = device
        
        if (device.type == EBIMobileDeviceTypeAndroid) {
            serialNumber = device.serialNumber
            platform = .Android
            formfactorName = "Android"
            name = device.deviceName
        }
        else {
            platform = .iOS
            formfactorName = device.deviceName
            name = ""
        }
    }
    
    func appendLog(string: String) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.appendLog(string: string)
            }
            return
        }
        NSLog("[%@] %@", name, string)
        log.append(string)
    }
}

extension Device {

    func equals(mobileDevice: EBIMobileDevice) -> Bool {
        if (self.platform == .iOS) && (mobileDevice.type == EBIMobileDeviceTypeIOS) {
        }
        else if (self.platform == .Android) && (mobileDevice.type == EBIMobileDeviceTypeAndroid) {
        }
        else {
            return false
        }
        
        if self.name.caseInsensitiveCompare(mobileDevice.deviceName) != .orderedSame {
            return false
        }
        if self.serialNumber.caseInsensitiveCompare(mobileDevice.serialNumber) != .orderedSame {
            return false
        }
        
        return true
    }
}
