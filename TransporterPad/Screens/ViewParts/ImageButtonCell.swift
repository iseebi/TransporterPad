//
//  ImageButtonCell.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/8/17.
//  Copyright © 2017 Nobuhiro Ito.
//

import Cocoa

class ImageButtonCell: NSButtonCell {
    
    override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        guard let button = controlView as? ImageButton else { return }
        if !button.isEnabled { return }
        if flag {
            button.image = button.highlightImage ?? button.normalImage
        }
        else {
            button.image = button.normalImage
        }
    }
}
