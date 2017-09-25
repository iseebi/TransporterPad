//
//  AppPackageIconValueTransformer.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/25.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class AppPackageIconValueTransformer: ValueTransformer {
    
    override static func transformedValueClass() -> AnyClass {
        return AnyObject.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let v = value as? AppPackage {
            if (v.platform == .Android) {
                return NSImage.init(named: "apk")
            }
            else if (v.platform == .iOS) {
                return NSImage.init(named: "ipa")
            }
        }
        return nil
    }
}
