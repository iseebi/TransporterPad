//
//  PlatformCommandManager.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/11.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TranspoterPad. Licensed in GPLv3.
//

import Cocoa
import CoreFoundation
import Alamofire
import SimpleUnzipper

class PlatformCommandManager {

    let downloadUrlString = "iseebi.half-done.net/files/TransporterPad_DeployTools.zip"
    let deployTools = ["ios-deploy", "aapt", "adb"]
    
    let deployToolsDirURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?
        .appendingPathComponent("DeployTools")
    
    lazy var hasCommands: Bool = {
        guard let toolDir = self.deployToolsDirURL else { return false }
        return self.deployTools.map({ toolDir.appendingPathComponent($0) })
            .filter({ !FileManager.default.fileExists(atPath: $0.absoluteString) })
            .count == 0
    }()
    
    init() {
        guard let toolDir = deployToolsDirURL else { return }
        var isDir : ObjCBool = false
        if (!FileManager.default.fileExists(atPath: toolDir.absoluteString, isDirectory: &isDir) || (!isDir.boolValue)) {
            try? FileManager.default.createDirectory(at: toolDir, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func download () {
        guard let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("deploytool.zip"),
              let toolsDirURL = deployToolsDirURL
            else { return }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (cachePath, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(downloadUrlString, to: destination)
            .downloadProgress(closure: { (progress) in
            })
            .response { response in
                if response.error == nil,
                    let resultURL = response.destinationURL,
                    let zip = SimpleUnzipper.init(fileURL: resultURL) {
                    for fileName in zip.files {
                        guard let data = zip.dataForFile(fileName) else { continue }
                        let filePath = toolsDirURL.appendingPathComponent(fileName)
                        try? data.write(to: filePath, options: .atomic)
                        try? FileManager.default.setAttributes([.posixPermissions : 0o700], ofItemAtPath: filePath.absoluteString)
                    }
                }
            }
    }
}
