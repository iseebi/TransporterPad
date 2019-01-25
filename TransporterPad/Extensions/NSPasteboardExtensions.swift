//
//  NSPasteboardExtensions.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 1/25/19.
//  Copyright © 2019 Nobuhiro Ito. All rights reserved.
//
//  This file is part of TransporterPad. Licensed in GPLv3.

import AppKit

extension NSPasteboard.PasteboardType  {
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
    } ()
    
    static let backwardsCompatibleURL: NSPasteboard.PasteboardType = {
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.URL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeURL as String)
        }
    } ()
}
