//
//  ImageButton.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/7/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

class ImageButton: NSButton {
    
    var normalImage: NSImage?
    var highlightImage: NSImage?
    var disableImage: NSImage?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonImage()
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonImage()
        }
    }

    func updateButtonImage() {
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
