//
//  AppPackageReader.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/24.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TranspoterPad. Licensed in GPLv3.
//

import Cocoa
import SimpleUnzipper
import EBIAXMLDecompressor

class AppPackageReader: NSObject {
    private let tempDirMgr: TemporaryDirectoryManager
    private static let ipaInfoPlistPattern: NSRegularExpression = {
        let pattern = try! NSRegularExpression(pattern: "Payload/[^/]+\\.app/Info.plist", options: .caseInsensitive)
        return pattern
    }()

    init(temporaryDirectoryManager: TemporaryDirectoryManager) {
        tempDirMgr = temporaryDirectoryManager
    }
    
    func read(fileURL: URL) -> AppPackage? {
        guard let zip = SimpleUnzipper(fileURL: fileURL) else { return nil }
        for file in zip.files {
            if (file == "AndroidManifest.xml") {
                // maybe apk
                guard let manifestData = zip.dataForFile(file),
                    let packageName = readAndroidManifest(data: manifestData)
                    else { return nil }
                return createAppPackage(fileURL: fileURL, platform: .Android, packageName: packageName)
            }
            else if (isFileNameInfoPlist(fileName: file)) {
                guard let infoData = zip.dataForFile(file),
                    let packageName = readInfoPlist(data: infoData)
                    else { return nil }
                return createAppPackage(fileURL: fileURL, platform: .iOS, packageName: packageName)
            }
        }
        return nil
    }
    
    private func createAppPackage(fileURL: URL, platform: Platform, packageName: String) -> AppPackage? {
        guard let tempDir = tempDirMgr.create() else { return nil }
        let packageURL = tempDir.url.appendingPathComponent(String(format: "package%@", platform.fileExtension))
        if ((try? FileManager.default.linkItem(at: fileURL, to: packageURL)) == nil) {
            tempDir.cleanup()
            return nil
        }
        return AppPackage(platform: platform, packageName: packageName, fileURL: packageURL, temporaryDirectory: tempDir)
    }

    private func isFileNameInfoPlist(fileName: String) -> Bool {
        guard let result = AppPackageReader.ipaInfoPlistPattern.firstMatch(in: fileName, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: fileName.utf16.count))
            else { return false }
        return !((result.range.location == NSNotFound) && (result.range.length == 0))
    }
    
    private func readInfoPlist(data: Data) -> String? {
        guard let tempDir = tempDirMgr.create() else { return nil }
        guard let tempFileURL = tempDir.writeNewTemporary(data: data),
            let dictionary = NSDictionary(contentsOf: tempFileURL)
            else {
                tempDir.cleanup()
                return nil
            }
        tempDir.cleanup()
        return dictionary.value(forKey: kCFBundleIdentifierKey as String) as? String
    }

    private func readAndroidManifest(data: Data) -> String? {
        guard let xml = EBIAXMLDecompressor.decompress(from: data) else { return nil }
        let parser = XMLParser(data: xml.data(using: .utf8)!)
        let parserDelegate = AndroidManifestParserDelegate()
        parser.delegate = parserDelegate
        parser.parse()
        return parserDelegate.packageName
    }

    private class AndroidManifestParserDelegate: NSObject, XMLParserDelegate {
        var packageName: String? = nil
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            if elementName != "manifest" { return }
            packageName = attributeDict["package"]
        }
    }
}
