//
//  ExtendedDrawingView.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/7/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

class ExtendedDrawingView: NSView {

    @objc var backgroundColor: NSColor?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let backgroundColor = self.backgroundColor {
            backgroundColor.setFill()
            dirtyRect.fill()
        }
    }
    
}
