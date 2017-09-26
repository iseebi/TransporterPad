//
//  DeviceCollectionViewItem.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class DeviceCollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var deviceImageView: NSImageView!
    
    deinit {
        self.representedObject = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateImage()
    }
    
    override var representedObject: Any? {
        willSet(newValue) {
            guard let device = representedObject as? Device else { return }
            device.removeObserver(self, forKeyPath: "compatible")
        }
        didSet(oldValue) {
            guard let device = representedObject as? Device else { return }
            device.addObserver(self, forKeyPath: "compatible", options: [.new], context: nil)
            updateImage()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "compatible") {
            updateImage()
        }
    }
    
    func updateImage() {
        if deviceImageView == nil { return }
        if let device = representedObject as? Device {
            if (device.platform == .Android) {
                deviceImageView.image =  device.compatible
                    ? NSImage(named: "device_android")
                    : NSImage(named: "device_android_disable")
            }
            else if (device.platform == .iOS) {
                deviceImageView.image = device.compatible
                    ? NSImage(named: "device_iphone")
                    : NSImage(named: "device_iphone_disable")
            }
        }
    }
}
