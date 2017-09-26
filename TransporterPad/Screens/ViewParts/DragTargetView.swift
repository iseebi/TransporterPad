//
//  DragTargetView.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

@objc protocol DragTargetViewDelegate: class {
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String)
    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String)
}

@objc class DragTargetView: NSView {

    @IBOutlet public weak var delegate: DragTargetViewDelegate!
    
    var enabled: Bool = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if !enabled {
            return .generic
        }
        if let _ = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as? [String] {
            return .copy
        }
        if let _ = sender.draggingPasteboard().propertyList(forType: NSURLPboardType) as? [String] {
            return .copy
        }
        return NSDragOperation()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if !enabled { return false }
        let pasteboard = sender.draggingPasteboard()
        if let path = (pasteboard.propertyList(forType: NSFilenamesPboardType) as? [String])?.first {
            self.delegate?.dragTargetView(self, dropLocalFilePath: path)
            return true;
        }
        if let path = (pasteboard.propertyList(forType: NSURLPboardType) as? [String])?.first {
            self.delegate?.dragTargetView(self, dropRemoteURL: path)
            return true;
        }
        return false;
    }
}
