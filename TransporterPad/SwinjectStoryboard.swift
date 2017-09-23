//
//  SwinjectStoryboard.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/15.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {

        // Primitive Objects
        defaultContainer.register(UserSettings.self) { _ in UserSettings() }
            .inObjectScope(.container)
        defaultContainer.register(Environment.self) { r in
            Environment(userSettings: r.resolve(UserSettings.self)!)
        }.inObjectScope(.container)
        defaultContainer.register(TemporaryDirectoryManager.self) { _ in TemporaryDirectoryManager()! }

        defaultContainer.register(DeviceWatcher.self) { _ in DeviceWatcher() }
            .inObjectScope(.container)


        // ViewModels
        defaultContainer.register(MainViewModel.self) { r in
            MainViewModel(deviceWatcher: r.resolve(DeviceWatcher.self)!)
        }

        // ViewControllers
        defaultContainer.storyboardInitCompleted(MainViewController.self) { r, c in
            c.viewModel = r.resolve(MainViewModel.self)!
        }
    }
}
