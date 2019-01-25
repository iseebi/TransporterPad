//
//  DragTargetView.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

@objc protocol DragTargetViewDelegate: class {
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String)
    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String)
}

@objcMembers class DragTargetView: ExtendedDrawingView {

    @IBOutlet public weak var delegate: DragTargetViewDelegate!
    
    var enabled: Bool = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForDraggedTypes([.backwardsCompatibleFileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if !enabled {
            return .generic
        }
        if let _ = sender.draggingPasteboard.propertyList(forType: .backwardsCompatibleFileURL) {
            return .copy
        }
        if let _ = sender.draggingPasteboard.propertyList(forType: .backwardsCompatibleURL) {
            return .copy
        }
        return NSDragOperation()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if !enabled { return false }
        guard let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [NSURL],
            let url = urls.first
            else { return false }
        
        if url.isFileURL {
            guard let path = url.path else { return false }
            self.delegate?.dragTargetView(self, dropLocalFilePath: path)
        }
        else {
            guard let absoluteString = url.absoluteString else { return false }
            self.delegate?.dragTargetView(self, dropRemoteURL: absoluteString)
        }
        return false
    }
}
