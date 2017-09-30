//
//  DeviceCollectionView.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 9/30/17.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

import Cocoa

protocol DeviceCollectionViewDelegate : class {
    func deviceCollectionView(_: DeviceCollectionView, deviceDetailRequested device: Device)
}

class DeviceCollectionView: NSCollectionView {

    var deviceCollectionViewDelegate: DeviceCollectionViewDelegate?
    
    func onDeviceDetailRequesting(_ device:Device) {
        deviceCollectionViewDelegate?.deviceCollectionView(self, deviceDetailRequested: device)
    }
}
