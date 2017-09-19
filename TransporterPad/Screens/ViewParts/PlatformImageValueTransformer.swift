//
//  PlatformImageValueTransformer.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class PlatformImageValueTransformer: ValueTransformer {

    override static func transformedValueClass() -> AnyClass {
        return AnyObject.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }

    override func transformedValue(_ value: Any?) -> Any? {
        return NSImage.init(named: "device_iphone")
    }
}
