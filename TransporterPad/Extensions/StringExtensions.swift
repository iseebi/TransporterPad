//
//  StringExtensions.swift
//  TransporterPad
//

import Foundation

// http://qiita.com/su_k/items/77345499e04de7f214ad
extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    public func substring(from index: Int) -> String {
        return ns.substring(from: index)
    }
    
    public func substring(to index: Int) -> String {
        return ns.substring(to: index)
    }
    
    public func substring(with range: NSRange) -> String {
        return ns.substring(with: range)
    }
    
    public var lastPathComponent: String {
        return ns.lastPathComponent
    }
    
    public var pathExtension: String {
        return ns.pathExtension
    }
    
    public var deletingLastPathComponent: String {
        return ns.deletingLastPathComponent
    }
    
    public var deletingPathExtension: String {
        return ns.deletingPathExtension
    }
    
    public var pathComponents: [String] {
        return ns.pathComponents
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return ns.appendingPathExtension(str)
    }
}

extension String {
    
    static func random(count: UInt) -> String {
        let chars = "abcdefghijklnmopqrstuvwxyz0123456789"
        var rv = ""
        for _ in 0..<count {
            let startIndex = Int(arc4random_uniform(UInt32(chars.lengthOfBytes(using: .utf8))))
            rv.append(chars.substring(with:
                chars.index(chars.startIndex, offsetBy: startIndex)..<chars.index(chars.startIndex, offsetBy: startIndex + 1)
            ))
        }
        return rv
    }
}
