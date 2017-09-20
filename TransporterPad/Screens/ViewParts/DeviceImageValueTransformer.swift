//
//  DeviceImageValueTransformer.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class DeviceImageValueTransformer: ValueTransformer {

    override static func transformedValueClass() -> AnyClass {
        return AnyObject.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }

    override func transformedValue(_ value: Any?) -> Any? {
        if let v = value as? Device {
            if (v.platform == .Android) {
                return NSImage.init(named: "device_android")
            }
            else if (v.platform == .iOS) {
                return NSImage.init(named: "device_iphone")
            }
        }
        return nil
    }
}
