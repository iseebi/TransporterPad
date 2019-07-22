//
//  ViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa
import CoreFoundation
//import Alamofire

class MainViewController: NSViewController {
    @IBOutlet weak var dragTargetView: DragTargetView!
    @IBOutlet weak var collectionView: DeviceCollectionView!
    @IBOutlet weak var reInstallCheck: NSButton!
    @IBOutlet weak var dropTargetButton: NSButton!

    @objc var viewModel: MainViewModel? {
        willSet {
            self.willChangeValue(forKey: "viewModel")
            
            guard let vm = viewModel else { return }
            vm.removeObserver(self, forKeyPath: "downloading")
            vm.removeObserver(self, forKeyPath: "progressValue")
            vm.removeObserver(self, forKeyPath: "beamupAvaliable")
            vm.removeObserver(self, forKeyPath: "devices")
        }
        didSet {
            self.didChangeValue(forKey: "viewModel")

            guard let vm = viewModel else { return }
            vm.addObserver(self, forKeyPath: "downloading", options: [.new], context: nil)
            vm.addObserver(self, forKeyPath: "progressValue", options: [.new], context: nil)
            vm.addObserver(self, forKeyPath: "beamupAvaliable", options: [.new], context: nil)
            vm.addObserver(self, forKeyPath: "devices", options: [.new], context: nil)
        }
    }
    
    @objc var statusIndicatorVisible: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "statusIndicatorVisible")
        }
        didSet {
            self.didChangeValue(forKey: "statusIndicatorVisible")
        }
    }
    
    @objc var progress: NSNumber = NSNumber(value: 0) {
        willSet {
            self.willChangeValue(forKey: "progress")
        }
        didSet {
            self.didChangeValue(forKey: "progress")
        }
    }
    
    @objc var progressIntermediate: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "progressIntermediate")
        }
        didSet {
            self.didChangeValue(forKey: "progressIntermediate")
        }
    }
    
    @objc var beamupEnabled: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "beamupEnabled")
        }
        didSet {
            self.didChangeValue(forKey: "beamupEnabled")
        }
    }
    
    @objc var hasDevices: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "hasDevices")
        }
        didSet {
            self.didChangeValue(forKey: "hasDevices")
        }
    }

    @objc var detailRequestedDevice: Device? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragTargetView.delegate = self
        collectionView.register(NSNib.init(nibNamed: "DeviceCollectionViewItem", bundle: nil), forItemWithIdentifier: convertToNSUserInterfaceItemIdentifier("DeviceCollectionViewItem"))
        collectionView.deviceCollectionViewDelegate = self
        
        dropTargetButton.wantsLayer = true
        dropTargetButton.shadow = NSShadow()
        if let layer = dropTargetButton.layer {
            layer.shadowPath = NSBezierPath(rect: layer.bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = view.window?.screen?.backingScaleFactor ?? 1.0
            layer.shadowColor = NSColor(calibratedRed: 25.0/255.0, green: 25.0/255.0, blue: 26.0/255.0, alpha: 0.4).cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 20
            layer.shadowOpacity = 1.0
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destinationController as? DeviceDetailViewController {
            detailVC.representedObject = detailRequestedDevice
        }
    }
    
    @IBAction func beamupTapped(_ sender: Any) {
        guard let vm = viewModel else { return }
        let reinstall = (reInstallCheck.state == .on)
        vm.startTransporter(reInstall: reinstall)
    }
}

extension MainViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "downloading") {
            updateStatusIndicatorState()
        }
        if (keyPath == "progressValue") {
            updateStatusIndicatorState()
        }
        if (keyPath == "beamupAvaliable") {
            updateStatusIndicatorState()
        }
        if (keyPath == "devices") {
            updateHasDevices()
        }
    }
    
    func updateStatusIndicatorState() {
        guard let vm = viewModel else { return }
        statusIndicatorVisible = NSNumber(value: vm.downloading)
        progressIntermediate = NSNumber(value: vm.progressValue < 0)
        progress = NSNumber(value: vm.progressValue)
        beamupEnabled = NSNumber(value: vm.beamupAvaliable)
    }
    
    func updateHasDevices() {
        guard let vm = viewModel else { return }
        hasDevices = NSNumber(value: vm.devices.count > 0)
    }
}

extension MainViewController: DeviceCollectionViewDelegate {
    func deviceCollectionView(_: DeviceCollectionView, deviceDetailRequested device: Device) {
        detailRequestedDevice = device
        performSegue(withIdentifier: "deviceDetail", sender: self)
    }
}

extension MainViewController : DragTargetViewDelegate {

    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String) {
        guard let vm = viewModel else { return }
        guard let url = URL(string: fileName) else { return }

        if !vm.dropRemoteItem(at: url, completeHandler: { result in
            if !result {
                // TODO: alert (ダウンロードしたファイルがipa/apkじゃなかった場合)
            }
        }, errorHandler: { err in
            // TODO: alert (ダウンロード失敗した場合)
        }) {
            // TODO: alert (ダウンロード開始できなかった場合)
        }
    }
    
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String) -> Bool {
        guard let vm = viewModel else { return false }

        let fileURL = URL(fileURLWithPath: fileName)
        return vm.dropLocalItem(at: fileURL)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSUserInterfaceItemIdentifier(_ input: String) -> NSUserInterfaceItemIdentifier {
	return NSUserInterfaceItemIdentifier(rawValue: input)
}
