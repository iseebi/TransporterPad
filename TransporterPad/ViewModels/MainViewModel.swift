//
//  MainViewModel.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class MainViewModel: NSObject {
    let deviceWatcher: DeviceWatcher
    let packageReader: AppPackageReader
    
    var appPackage: AppPackage? = nil {
        willSet {
            willChangeValue(forKey: "appPackage")
        }
        didSet(oldValue) {
            oldValue?.cleanup()
            validateDevices()
            didChangeValue(forKey: "appPackage")
        }
    }
    
    var devices: [Device] {
        get { return deviceWatcher.devices }
    }
    
    init(deviceWatcher: DeviceWatcher, appPackageReader: AppPackageReader) {
        self.deviceWatcher = deviceWatcher
        self.packageReader = appPackageReader
        super.init()
        deviceWatcher.delegate = self
        deviceWatcher.start()
    }
    
    func dropLocalItem(at: URL) -> Bool {
        if let package = packageReader.read(fileURL: at) {
            appPackage = package
            return true
        }
        else {
            appPackage = nil
            return false
        }
    }
    
    func validateDevices() {
        for device in devices {
            validateDevice(device: device)
        }
    }
    
    func validateDevice(device: Device) {
        device.compatible = appPackage?.platform == device.platform
    }
}

extension MainViewModel: DeviceWatcherDelegate {
    func deviceWatcher(_: DeviceWatcher, addedDevice device: Device) {
        willChangeValue(forKey: "devices")
        validateDevice(device: device)
        didChangeValue(forKey: "devices")
    }
    
    func deviceWatcher(_: DeviceWatcher, didRemovedDevice at: Int) {
        willChangeValue(forKey: "devices")
        didChangeValue(forKey: "devices")
    }
}
