//
//  ImageButton.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/7/17.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//
//  This file is part of TranspoterPad. Licensed in GPLv3.
//

import Cocoa

class ImageButton: NSButton {
    
    var normalImage: NSImage?
    var highlightImage: NSImage?
    var disableImage: NSImage?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func updateLayer() {
        if isEnabled {
            if isHighlighted {
                image = highlightImage ?? normalImage
            }
            else {
                image = normalImage
            }
        }
        else {
            image = disableImage ?? normalImage
        }
    }
}
