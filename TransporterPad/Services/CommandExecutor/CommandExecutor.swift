//
//  CommandExecutor.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/29.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

protocol CommandExecutorDelegate: class {
    func commandExecutor(_: CommandExecutor, receiveStandardInput input: String)
    func commandExecutor(_: CommandExecutor, receiveStandardError input: String)
    func commandExecutor(_: CommandExecutor, processTerminated statusCode: Int)
}

class CommandExecutor: NSObject {

    let environment: Environment
    weak var delegate: CommandExecutorDelegate?

    fileprivate let proc: Process
    fileprivate let stdOutPipe: Pipe
    fileprivate let stdErrPipe: Pipe

    init(environment: Environment) {
        self.environment = environment
        proc = Process()
        stdOutPipe = Pipe()
        stdErrPipe = Pipe()
        proc.standardOutput = stdOutPipe
        proc.standardError = stdErrPipe
        super.init()
    }
    
    func run() {
        if (proc.isRunning) { return }

        proc.terminationHandler = { [weak self] _ in
            guard let sself = self else { return }
            sself.onTerminate()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onStandardInputReceived),
                                               name: FileHandle.readCompletionNotification,
                                               object: stdOutPipe.fileHandleForReading)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onErrorInputReceived),
                                               name: FileHandle.readCompletionNotification,
                                               object: stdErrPipe.fileHandleForReading)
        
        stdOutPipe.fileHandleForReading.readInBackgroundAndNotify()
        stdErrPipe.fileHandleForReading.readInBackgroundAndNotify()
        
        proc.launch()
    }
    
    @objc private func onStandardInputReceived(notification: Notification) {
        if let d = delegate,
            let userInfo = notification.userInfo,
            let dataItem = userInfo[NSFileHandleNotificationDataItem] as? Data,
            let str = String.init(data: dataItem, encoding: .utf8) {
            d.commandExecutor(self, receiveStandardInput: str)
        }
        if proc.isRunning {
            stdOutPipe.fileHandleForReading.readInBackgroundAndNotify()
        }
    }
    
    @objc private func onErrorInputReceived(notification: Notification) {
        if let d = delegate,
            let userInfo = notification.userInfo,
            let dataItem = userInfo[NSFileHandleNotificationDataItem] as? Data,
            let str = String.init(data: dataItem, encoding: .utf8) {
            d.commandExecutor(self, receiveStandardError: str)
        }
        if proc.isRunning {
            stdErrPipe.fileHandleForReading.readInBackgroundAndNotify()
        }
    }
    
    private func onTerminate() {
        proc.terminationHandler = nil
        NotificationCenter.default.removeObserver(self)
        
        guard let d = delegate else { return }
        d.commandExecutor(self, processTerminated: Int(proc.terminationStatus))
    }
}

extension CommandExecutor {
    class func deployCommandExecutor(environment: Environment, package: AppPackage, device: Device) -> CommandExecutor {
        let executor = CommandExecutor(environment: environment)
        if package.platform == .Android {
            executor.proc.launchPath = environment.adbToolPath
            executor.proc.arguments = ["-s", device.serialNumber, "install", package.fileURL.absoluteString]
        }
        else if package.platform == .iOS {
            executor.proc.launchPath = environment.iosDeployToolPath
            executor.proc.arguments = ["-i", device.serialNumber, "-b", package.fileURL.absoluteString]
        }
        else {
            preconditionFailure("missing deployCommand implementation")
        }
        return executor
    }

    class func uninstallCommandExecutor(environment: Environment, package: AppPackage, device: Device) -> CommandExecutor {
        let executor = CommandExecutor(environment: environment)
        if package.platform == .Android {
            executor.proc.launchPath = environment.adbToolPath
            executor.proc.arguments = ["-s", device.serialNumber, "uninstall", package.packageName]
        }
        else if package.platform == .iOS {
            executor.proc.launchPath = environment.iosDeployToolPath
            executor.proc.arguments = ["-i", device.serialNumber, "-9", "-1", package.packageName]
        }
        else {
            preconditionFailure("missing uninstallCommand implementation")
        }
        return executor
    }
}
