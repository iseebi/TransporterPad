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

class MainViewController: NSViewController {
    @IBOutlet weak var dragTargetView: DragTargetView!
    @IBOutlet weak var collectionView: NSCollectionView!

    var viewModel: MainViewModel? {
        willSet {
            self.willChangeValue(forKey: "viewModel")
            viewModel?.removeObserver(self, forKeyPath: "viewModel")
        }
        didSet {
            self.didChangeValue(forKey: "viewModel")
            viewModel?.addObserver(self, forKeyPath: "viewModel", options: [.new], context: nil)
        }
    }
    
    var statusIndicatorVisible: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "statusIndicatorVisible")
        }
        didSet {
            self.didChangeValue(forKey: "statusIndicatorVisible")
        }
    }
    
    var progress: NSNumber = NSNumber(value: 0) {
        willSet {
            self.willChangeValue(forKey: "progress")
        }
        didSet {
            self.didChangeValue(forKey: "progress")
        }
    }
    
    var progressIntermediate: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "progressIntermediate")
        }
        didSet {
            self.didChangeValue(forKey: "progressIntermediate")
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragTargetView.delegate = self
        collectionView.register(NSNib.init(nibNamed: "DeviceCollectionViewItem", bundle: nil), forItemWithIdentifier: "DeviceCollectionViewItem")
    }
}

extension MainViewController : DragTargetViewDelegate {

    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String) {
        NSLog("Remote file:%@", fileName)
        
        downloadFile(remoteURLString: fileName)
    }
    
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String) {
        NSLog("Local file:%@", fileName)
        guard let vm = viewModel else { return }

        let fileURL = URL(fileURLWithPath: fileName)
        if !vm.dropLocalItem(at: fileURL) {
            // TODO: alert
        }
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

/*
extension MainViewController : NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 0
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.devices.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "DeviceCollectionViewItem", for:indexPath)
        if let vm = viewModel  {
            item.representedObject = vm.devices[indexPath.item]
        }
        return item
    }
}
*/

