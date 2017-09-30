//
//  AppPackage.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/18.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TranspoterPad. Licensed in GPLv3.
//

import Foundation

class AppPackage: NSObject {
    let platform: Platform
    let packageName: String
    let fileURL: URL
    var temporaryDirectory: TemporaryDirectory? = nil
    
    init(platform: Platform, packageName: String, fileURL: URL, temporaryDirectory: TemporaryDirectory?) {
        self.platform = platform
        self.packageName = packageName
        self.fileURL = fileURL
        self.temporaryDirectory = temporaryDirectory
    }
    
    func cleanup() {
        temporaryDirectory?.cleanup()
        temporaryDirectory = nil
    }
}
