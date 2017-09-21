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
    
    var devices: [Device] {
        get { return deviceWatcher.devices }
    }
    
    init(deviceWatcher: DeviceWatcher) {
        self.deviceWatcher = deviceWatcher
        super.init()
        deviceWatcher.delegate = self
        deviceWatcher.start()
    }
}

extension MainViewModel: DeviceWatcherDelegate {
    func deviceWatcherAddedDevice(_: DeviceWatcher) {
        willChangeValue(forKey: "devices")
        didChangeValue(forKey: "devices")
    }
    
    func deviceWatcher(_: DeviceWatcher, didRemovedDevice at: Int) {
        willChangeValue(forKey: "devices")
        didChangeValue(forKey: "devices")
    }

}
