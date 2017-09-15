//
//  ViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa
import CoreFoundation
import Alamofire

class ViewController: NSViewController {

    @IBOutlet var dragTargetView: DragTargetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragTargetView.delegate = self
    }


}

extension ViewController : DragTargetViewDelegate {

    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String) {
        NSLog("Remote file:%@", fileName)
        
        downloadFile(remoteURLString: fileName)
    }
    
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String) {
        NSLog("Local file:%@", fileName)
        
        processBinary(fileName: fileName)
    }
    
    func processBinary(fileName: String) {
        // ipa かどうか
        
        // apk かどうか
    }

    func downloadFile(remoteURLString: String) {
        guard let cacheDir = cacheDir() else { return }
        let cachePath = cacheFilePath(remoteURLString: remoteURLString, cacheDir: cacheDir)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (cachePath, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(remoteURLString, to: destination).response { [weak self] response in
            if response.error == nil, let resultPath = response.destinationURL?.path {
                self?.processBinary(fileName: resultPath)
            }
        }
    }
    
    func cacheFilePath(remoteURLString: String, cacheDir: URL) -> URL {
        var fileURL: URL = cacheDir
        repeat {
            let ext = remoteURLString.pathExtension
            let fileName = String.random(count: 16).appending(ext)
            fileURL = cacheDir.appendingPathComponent(fileName)
        } while (!FileManager.default.fileExists(atPath: fileURL.absoluteString))
        return fileURL
    }

    func cacheDir() -> URL? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let binDir = cacheDir.appendingPathComponent("binaries", isDirectory: true)
        if (!FileManager.default.fileExists(atPath: binDir.absoluteString)) {
            if (try? FileManager.default.createDirectory(at: binDir, withIntermediateDirectories: true, attributes: nil)) == nil { return nil }
        }
        return binDir
    }
}
