//
//  ExtendedDrawingView.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/7/17.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//
//  This file is part of TranspoterPad. Licensed in GPLv3.
//

import Cocoa

class ExtendedDrawingView: NSView {

    var backgroundColor: NSColor?
    
    override func draw(_ dirtyRect: NSRect) {
        if let backgroundColor = self.backgroundColor {
            backgroundColor.setFill()
            NSRectFill(dirtyRect)
        }
        super.draw(dirtyRect)
    }
    
}
