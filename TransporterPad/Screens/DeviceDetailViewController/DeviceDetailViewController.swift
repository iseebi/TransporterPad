//
//  DeviceDetailViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 9/30/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TranspoterPad. Licensed in GPLv3.
//

import Cocoa

class DeviceDetailViewController: NSViewController {
    @IBOutlet weak var logScrollView: NSScrollView!
    @IBOutlet weak var logTextView: NSTextView!
    
    override var representedObject: Any? {
        willSet {
            self.willChangeValue(forKey: "deviceInformationString")
            
            guard let device = representedObject as? Device else { return }
            device.removeObserver(self, forKeyPath: "log")
        }
        didSet {
            self.didChangeValue(forKey: "deviceInformationString")

            updateLog()
            guard let device = representedObject as? Device else { return }
            device.addObserver(self, forKeyPath: "log", options: [.new], context: nil)
        }
    }

    var deviceInformationString: String {
        get {
            var result = ""
            if let device = representedObject as? Device {
                result = result + "\(device.name) [\(device.platform)] \(device.serialNumber)"
            }
            return result
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLog()
    }
    
    fileprivate func updateLog() {
        if logTextView == nil { return }
        guard let layoutManager = logTextView.layoutManager,
            let device = representedObject as? Device
            else { return }
        
        let smartScroll = (NSMaxY(logTextView.visibleRect) == NSMaxY(logTextView.bounds));
    
        layoutManager.replaceTextStorage(NSTextStorage(string: device.log, attributes: nil))
        
        if smartScroll {
            logTextView.scrollRangeToVisible(NSRange(location: logTextView.string?.count ?? 0, length: 0))
        }
    }
    
    @IBAction func okTapped(_ sender: Any) {
        dismissViewController(self)
    }
}

extension DeviceDetailViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "log") {
            updateLog()
        }
    }
}
