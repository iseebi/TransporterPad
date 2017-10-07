//
//  SwinjectStoryboard.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/15.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
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
        defaultContainer.register(TemporaryDirectoryManager.self) { _ in TemporaryDirectoryManager()! } // TODO !を外して起動エラーメッセージとかにしたい
            .inObjectScope(.container)
        defaultContainer.register(AppPackageReader.self) { r in AppPackageReader(temporaryDirectoryManager: r.resolve(TemporaryDirectoryManager.self)!) }
            .inObjectScope(.container)
        defaultContainer.register(DeviceWatcher.self) { _ in DeviceWatcher() }
            .inObjectScope(.container)
        defaultContainer.register(Transporter.self) { r in Transporter(environment: r.resolve(Environment.self)!) }
            .inObjectScope(.container)

        // ViewModels
        defaultContainer.register(MainViewModel.self) { r in
            MainViewModel(deviceWatcher: r.resolve(DeviceWatcher.self)!,
                          appPackageReader: r.resolve(AppPackageReader.self)!,
                          temporaryDirectoryManager: r.resolve(TemporaryDirectoryManager.self)!,
                          transporter: r.resolve(Transporter.self)!)
        }

        // ViewControllers
        defaultContainer.storyboardInitCompleted(MainViewController.self) { r, c in
            c.viewModel = r.resolve(MainViewModel.self)!
        }
        defaultContainer.storyboardInitCompleted(DeviceDetailViewController.self) { r, c in
        }
        defaultContainer.storyboardInitCompleted(AboutViewController.self) { _, _ in
        }
        defaultContainer.storyboardInitCompleted(LicenseViewController.self) { _, _ in
        }

        // (Fail Guards)
        defaultContainer.storyboardInitCompleted(NSWindowController.self) { _, _ in
        }
        defaultContainer.storyboardInitCompleted(NSViewController.self) { _, _ in
        }
    }
}
