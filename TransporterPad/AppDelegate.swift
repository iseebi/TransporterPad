//
//  AppDelegate.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
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
        ValueTransformer.setValueTransformer(DeviceImageValueTransformer.init(), forName:NSValueTransformerName(rawValue: "DeviceImageValueTransformer"))
        
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


}

