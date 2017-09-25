//
//  DeviceWatcher.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/20.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa
import EBIMobileDeviceWatcher
import EBIiOSDeviceWatcher

protocol DeviceWatcherDelegate: class {
    func deviceWatcher(_: DeviceWatcher, addedDevice device: Device)
    func deviceWatcher(_: DeviceWatcher, didRemovedDevice at: Int)
}

class DeviceWatcher: NSObject {
    
    var devices: [Device] = []
    weak var delegate: DeviceWatcherDelegate?
    
    /// iOS デバイスのUDIDから端末名を取得するディクショナリ
    var iosNames: [String:String] = [:]

    private let mobileDeviceWatcher = EBIMobileDeviceWatcher()
    private let iosDeviceWatcher = EBIiOSDeviceWatcher()
    
    override init() {
        super.init()
        mobileDeviceWatcher.delegate = self
        iosDeviceWatcher.delegate = self
    }

    func start() {
        devices.removeAll()
        mobileDeviceWatcher.startWatching()
        iosDeviceWatcher.startWatching()
    }
    
    func stop() {
        mobileDeviceWatcher.stopWatching()
        iosDeviceWatcher.stopWatching()
    }
    
    fileprivate func connectedDevice(newDevice: EBIMobileDevice) {
        let device = Device(device: newDevice)
        if (device.platform == .iOS) {
            if let name = iosNames[device.serialNumber] {
                device.name = name
            }
        }
        devices.append(device)
        delegate?.deviceWatcher(self, addedDevice: device)
    }

    fileprivate func disconnectedDevice(disconnectedDevice: EBIMobileDevice) {
        
        let removes = devices.filter { d -> Bool in
            guard let md = d.mobileDevice else { return true }
            return md == disconnectedDevice
        }
        removes.forEach { [weak self] device in
            guard let index = devices.index(of: device) else { return }
            devices.remove(at: index)
            
            guard let sself = self else { return }
            sself.delegate?.deviceWatcher(sself, didRemovedDevice: index)
        }
    }

    fileprivate func iosDeviceNameChanged(newName: String, udid: String) {
        if (iosNames[udid] != newName) {
            iosNames[udid] = newName
            devices.forEach({ device in
                if ((device.platform == .iOS) && (device.serialNumber.caseInsensitiveCompare(udid) == .orderedSame)) {
                    device.name = newName
                }
            })
        }
    }
}

extension DeviceWatcher: EBIMobileDeviceWatcherDelegate {
    func mobileDeviceWatcherStarted(_ watcher: EBIMobileDeviceWatcher!) {
        
    }
    
    func mobileDeviceWatcherStopped(_ watcher: EBIMobileDeviceWatcher!) {
        
    }
    
    func mobileDeviceWatcher(_ watcher: EBIMobileDeviceWatcher!, didDiscoveredMobileDevice device: EBIMobileDevice!) {
        connectedDevice(newDevice: device)
    }
    
    func mobileDeviceWatcher(_ watcher: EBIMobileDeviceWatcher!, didDisconnectedMobileDevice device: EBIMobileDevice!) {
        disconnectedDevice(disconnectedDevice: device)
    }
}

extension DeviceWatcher: EBIiOSDeviceWatcherDelegate {
    func iosDeviceWatcherStarted(_ watcher: EBIiOSDeviceWatcher!) {
        
    }
    
    func iosDeviceWatcherStopped(_ watcher: EBIiOSDeviceWatcher!) {
        
    }
    
    func iosDeviceWatcher(_ watcher: EBIiOSDeviceWatcher!, didDiscoveredMobileDevice device: EBIiOSDevice!) {
        iosDeviceNameChanged(newName: device.name, udid: device.udid)
    }
    
    func iosDeviceWatcher(_ watcher: EBIiOSDeviceWatcher!, didDisconnectedMobileDevice device: EBIiOSDevice!) {
        
    }
}
