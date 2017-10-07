//
//  FileManagerExtensions.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/23.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.

import Foundation

extension FileManager {
    func createTemporaryName(inDirectoryURL: URL) -> URL {
        var newURL: URL? = nil
        while newURL == nil {
            let url = inDirectoryURL.appendingPathComponent(String.random(count: 16))
            if !fileExists(atPath: url.absoluteString) {
                newURL = url
            }
        }
        return newURL!
    }
}
