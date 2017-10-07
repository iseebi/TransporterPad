//
//  AppDelegate.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa
import Swinject
import SwinjectStoryboard

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowController: NSWindowController!
    var container: Container!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        // Register ValueTransformers
        ValueTransformer.setValueTransformer(AppPackageIconValueTransformer.init(), forName:NSValueTransformerName(rawValue: "AppPackageIconValueTransformer"))
        
        container = SwinjectStoryboard.defaultContainer

        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil)
        
        windowController = sb.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        windowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let tempMgr = container.resolve(TemporaryDirectoryManager.self)!
        tempMgr.cleunup()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

