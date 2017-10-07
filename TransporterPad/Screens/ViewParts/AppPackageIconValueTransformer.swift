//
//  AppPackageIconValueTransformer.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/25.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
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
                return #imageLiteral(resourceName: "apk")
            }
            else if (v.platform == .iOS) {
                return #imageLiteral(resourceName: "ipa")
            }
        }
        return #imageLiteral(resourceName: "bg_drophere")
    }
}
