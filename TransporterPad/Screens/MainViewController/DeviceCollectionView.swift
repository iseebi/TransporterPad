//
//  DeviceCollectionView.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 9/30/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
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
