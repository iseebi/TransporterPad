//
//  AppDelegate.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowController: NSWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        //let app = NSApplication.shared()
        let sb = NSStoryboard.init(name: "Main", bundle: nil)
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "first") {
            defaults.set(true, forKey: "first")
            windowController = sb.instantiateController(withIdentifier: "FirstLaunchWindow") as! NSWindowController
        }
        else {
            windowController = sb.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
            windowController.showWindow(self)
        }
        windowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

