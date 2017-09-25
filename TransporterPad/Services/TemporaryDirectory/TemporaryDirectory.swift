//
//  TemporaryDirectory.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/22.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class TemporaryDirectory {

    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func writeNewTemporary(data: Data) -> URL? {
        let fm = FileManager.default
        let target = fm.createTemporaryName(inDirectoryURL: url)
        if (try? data.write(to: target)) != nil {
            return target
        }
        else {
            return nil
        }
    }
    
    func cleanup() {
        let fm = FileManager.default
        try? fm.removeItem(at: url)
    }
}
