//
//  CommandExecutor.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/29.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa

protocol CommandExecutorDelegate: class {
    func commandExecutor(_: CommandExecutor, receiveStandardInput input: String)
    func commandExecutor(_: CommandExecutor, receiveStandardError input: String)
    func commandExecutor(_: CommandExecutor, processTerminated statusCode: Int)
}

class CommandExecutor: NSObject {

    let environment: Environment
    let launchPath: String
    let arguments: [String]

    weak var delegate: CommandExecutorDelegate?

    fileprivate var runningThread: Thread? = nil
    fileprivate var proc: Process? = nil
    fileprivate var stdOutPipe: Pipe? = nil
    fileprivate var stdErrPipe: Pipe? = nil

    init(environment: Environment, launchPath: String, arguments: [String]) {
        self.environment = environment
        self.launchPath = launchPath
        self.arguments = arguments
        super.init()
    }
    
    func run() {
        if (self.proc?.isRunning ?? false) { return }
        let thread = Thread.init(target: self, selector: #selector(CommandExecutor.threadAction), object: nil)
        runningThread = thread
        thread.start()
    }
    
    @objc fileprivate func threadAction() {
        let proc = Process()
        let stdOutPipe = Pipe()
        let stdErrPipe = Pipe()
        
        self.proc = proc
        self.stdOutPipe = stdOutPipe
        self.stdErrPipe = stdErrPipe
        
        proc.standardInput = Pipe()
        proc.standardOutput = stdOutPipe
        proc.standardError = stdErrPipe
        proc.environment = ["NSUnbufferedIO": "YES"]
        proc.launchPath = self.launchPath
        proc.arguments = self.arguments
        
        stdOutPipe.fileHandleForReading.readabilityHandler = { [weak self] h in
            self?.onStandardInputReceived(data: h.availableData)
        }
        stdErrPipe.fileHandleForReading.readabilityHandler = { [weak self] h in
            self?.onErrorInputReceived(data: h.availableData)
        }
        proc.launch()
        proc.waitUntilExit()
        self.onTerminate()
    }
    
    func onStandardInputReceived(data: Data) {
        if let delegate = self.delegate,
            let str = String.init(data: data, encoding: .utf8) {
            delegate.commandExecutor(self, receiveStandardInput: str)
        }
    }
    
    func onErrorInputReceived(data: Data) {
        if let delegate = self.delegate,
            let str = String.init(data: data, encoding: .utf8) {
            delegate.commandExecutor(self, receiveStandardError: str)
        }
    }
    
    func onTerminate() {
        guard let proc = proc else { return }
        stdOutPipe?.fileHandleForReading.readabilityHandler = nil
        stdErrPipe?.fileHandleForReading.readabilityHandler = nil
        proc.terminationHandler = nil
        
        stdOutPipe = nil
        stdErrPipe = nil
        self.proc = nil
        runningThread = nil
        
        guard let d = delegate else { return }
        d.commandExecutor(self, processTerminated: Int(proc.terminationStatus))
    }
}

extension CommandExecutor {
    class func deployCommandExecutor(environment: Environment, package: AppPackage, device: Device) -> CommandExecutor {
        var launchPath: String
        var arguments: [String]
        if package.platform == .Android {
            launchPath = environment.adbToolPath
            arguments = ["-s", device.serialNumber, "install", "-r", package.fileURL.path]
        }
        else if package.platform == .iOS {
            launchPath = environment.iosDeployToolPath
            arguments = ["-i", device.serialNumber, "-b", package.fileURL.path]
        }
        else {
            preconditionFailure("missing deployCommand implementation")
        }
        return CommandExecutor(environment: environment, launchPath: launchPath, arguments: arguments)
    }

    class func uninstallCommandExecutor(environment: Environment, package: AppPackage, device: Device) -> CommandExecutor {
        var launchPath: String
        var arguments: [String]
        if package.platform == .Android {
            launchPath = environment.adbToolPath
            arguments = ["-s", device.serialNumber, "uninstall", package.packageName]
        }
        else if package.platform == .iOS {
            launchPath = environment.iosDeployToolPath
            arguments = ["-i", device.serialNumber, "-9", "-1", package.packageName]
        }
        else {
            preconditionFailure("missing uninstallCommand implementation")
        }
        return CommandExecutor(environment: environment, launchPath: launchPath, arguments: arguments)
    }
}
