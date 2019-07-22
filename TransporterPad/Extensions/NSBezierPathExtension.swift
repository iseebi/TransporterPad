//
//  NSBezierPathExtension.swift
//  TransporterPad
//

import Cocoa

// https://qiita.com/Kyomesuke3/items/4b00fe30c71196cba304
extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path: CGMutablePath = CGMutablePath()
        var points = [NSPoint](repeating: NSPoint.zero, count: 3)
        for i in (0 ..< self.elementCount) {
            switch self.element(at: i, associatedPoints: &points) {
            case .moveTo:
                path.move(to: CGPoint(x: points[0].x, y: points[0].y))
            case .lineTo:
                path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
            case .curveTo:
                path.addCurve(to: CGPoint(x: points[2].x, y: points[2].y),
                              control1: CGPoint(x: points[0].x, y: points[0].y),
                              control2: CGPoint(x: points[1].x, y: points[1].y))
            case .closePath:
                path.closeSubpath()
            }
        }
        return path
    }
}
