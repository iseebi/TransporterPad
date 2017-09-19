//
//  MainViewModel.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class MainViewModel: NSObject {

    var devices: [Device] = []
    
    override init() {
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
        devices.append(Device(platform: .iOS, name: "iPhone", serialNumber: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
        devices.append(Device(platform: .Android, name: "Xperia", serialNumber: "ZZZZZZZZ"))
    }
}
