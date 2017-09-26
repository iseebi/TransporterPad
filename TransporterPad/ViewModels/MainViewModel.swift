//
//  MainViewModel.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/19.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa
import Alamofire

class MainViewModel: NSObject {
    let deviceWatcher: DeviceWatcher
    let packageReader: AppPackageReader
    let tempDirManager: TemporaryDirectoryManager
    
    var devices: [Device] {
        get { return deviceWatcher.devices }
    }
    
    var appPackage: AppPackage? = nil {
        willSet {
            willChangeValue(forKey: "appPackage")
        }
        didSet(oldValue) {
            oldValue?.cleanup()
            validateDevices()
            didChangeValue(forKey: "appPackage")
        }
    }
    
    var downloading: Bool = false {
        willSet {
            willChangeValue(forKey: "downloading")
        }
        didSet(oldValue) {
            didChangeValue(forKey: "downloading")
        }
    }
    
    var progressValue: Int = -1 {
        willSet {
            willChangeValue(forKey: "progressValue")
        }
        didSet(oldValue) {
            didChangeValue(forKey: "progressValue")
        }
    }

    init(deviceWatcher: DeviceWatcher, appPackageReader: AppPackageReader, temporaryDirectoryManager: TemporaryDirectoryManager) {
        self.deviceWatcher = deviceWatcher
        self.packageReader = appPackageReader
        self.tempDirManager = temporaryDirectoryManager
        super.init()
        deviceWatcher.delegate = self
        deviceWatcher.start()
    }
}

extension MainViewModel {

    func validateDevices() {
        for device in devices {
            validateDevice(device: device)
        }
    }
    
    func validateDevice(device: Device) {
        device.compatible = appPackage?.platform == device.platform
    }
}

extension MainViewModel {
    
    func dropLocalItem(at: URL) -> Bool {
        if let package = packageReader.read(fileURL: at) {
            appPackage = package
            return true
        }
        else {
            appPackage = nil
            return false
        }
    }
    
    func dropRemoteItem(at: URL, completeHandler:@escaping (Bool) -> (), errorHandler:@escaping (Error) -> ()) -> Bool {
        guard let tempDir = tempDirManager.create() else { return false }
        let tempFile = tempDir.url.appendingPathComponent("downloadtemp")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (tempFile, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        downloading = true
        progressValue = -1
        Alamofire.download(at, to: destination)
            .downloadProgress { [weak self] progress in
                guard let sself = self else { return }
                sself.progressValue = Int(progress.fractionCompleted * 100)
        }
            .response { [weak self] response in
                guard let sself = self else { return }
                if let err = response.error {
                    // call error handler
                    errorHandler(err)
                }
                else if let _ = response.response {
                    completeHandler(sself.dropLocalItem(at: tempFile))
                }
                tempDir.cleanup()
                sself.downloading = false
        }
        return true
    }
}

extension MainViewModel: DeviceWatcherDelegate {
    func deviceWatcher(_: DeviceWatcher, addedDevice device: Device) {
        willChangeValue(forKey: "devices")
        validateDevice(device: device)
        didChangeValue(forKey: "devices")
    }
    
    func deviceWatcher(_: DeviceWatcher, didRemovedDevice at: Int) {
        willChangeValue(forKey: "devices")
        didChangeValue(forKey: "devices")
    }
}
