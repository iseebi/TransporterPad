//
//  DeviceCollectionViewItem.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

class DeviceCollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var deviceImageView: NSImageView!
    @IBOutlet weak var statusImageView: NSImageView!
    
    deinit {
        self.representedObject = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDeviceImage()
    }
    
    @IBAction func detailButtonTapped(_ sender: Any) {
        guard let deviceCollectionView = collectionView as? DeviceCollectionView,
            let device = self.representedObject as? Device
            else { return }
        deviceCollectionView.onDeviceDetailRequesting(device)
    }
    
    override var representedObject: Any? {
        willSet {
            guard let device = representedObject as? Device else { return }
            device.removeObserver(self, forKeyPath: "compatible")
            device.removeObserver(self, forKeyPath: "isNotchDevice")
            device.removeObserver(self, forKeyPath: "status")
        }
        didSet {
            guard let device = representedObject as? Device else { return }
            device.addObserver(self, forKeyPath: "compatible", options: [.new], context: nil)
            device.addObserver(self, forKeyPath: "isNotchDevice", options: [.new], context: nil)
            device.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
            updateDeviceImage()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "compatible" || keyPath == "isNotchDevice") {
            updateDeviceImage()
        }
        else if (keyPath == "status") {
            updateStatusImage()
        }
    }

    private func updateDeviceImage() {
        if deviceImageView == nil { return }
        if let device = representedObject as? Device {
            if (device.platform == .Android) {
                deviceImageView.image =  device.compatible
                    ? #imageLiteral(resourceName: "device_android")
                    : #imageLiteral(resourceName: "device_android_disable")
            }
            else if (device.platform == .iOS) {
                if (device.formfactorName.starts(with: "iPad")) {
                    deviceImageView.image = device.compatible
                        ? #imageLiteral(resourceName: "device_ipad")
                        : #imageLiteral(resourceName: "device_ipad_disable")
                }
                else if (device.isNotchDevice) {
                    deviceImageView.image = device.compatible
                        ? #imageLiteral(resourceName: "device_iphonex")
                        : #imageLiteral(resourceName: "device_iphonex_disable")
                }
                else {
                    deviceImageView.image = device.compatible
                        ? #imageLiteral(resourceName: "device_iphone")
                        : #imageLiteral(resourceName: "device_iphone_disable")
                }
            }
            else {
                preconditionFailure("Unimplemented platform")
            }
        }
    }

    private func updateStatusImage() {
        if statusImageView == nil { return }
        if let device = representedObject as? Device {
            if device.status == .Waiting {
                statusImageView.image = #imageLiteral(resourceName: "status_waiting")
                return
            }
            else if device.status == .Transporting {
                statusImageView.image = #imageLiteral(resourceName: "status_transporting")
                return
            }
            else if device.status == .Complete {
                statusImageView.image = #imageLiteral(resourceName: "status_complete")
                return
            }
            else if device.status == .Error {
                statusImageView.image = #imageLiteral(resourceName: "status_error")
                return
            }
        }
        statusImageView.image = nil
    }
}
