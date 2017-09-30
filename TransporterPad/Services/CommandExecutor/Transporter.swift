//
//  Transporter.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/29.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

import Cocoa

protocol TransporterDelegate: class {
    func transporterStart(_: Transporter)
    func transporterFinished(_: Transporter)
}

class Transporter: NSObject {

    let environment: Environment
    var delegate: TransporterDelegate?
    var working: Bool = false
    
    fileprivate var commandQueue: [TransporterQueueItem] = []
    fileprivate var workingExecutor: CommandExecutor? = nil
    fileprivate var workingExecutorDelegate: TransporterCommandExecutorDelegate? = nil
    
    init(environment: Environment) {
        self.environment = environment
        super.init()
    }
    
    func transport(package: AppPackage, targetDevices: [Device], reInstall: Bool) {
        if working { return }
        let devices = targetDevices.filter { d in d.platform == package.platform }
        devices.forEach{ d in d.status = .Waiting }
        commandQueue = []
        
        for device in devices {
            if reInstall {
                commandQueue.append(TransporterQueueItem(command: .Uninstall, package: package, device: device))
            }
            commandQueue.append(TransporterQueueItem(command: .Install, package: package, device: device))
        }
        
        // begin
        NSLog("[TP] begin work")
        working = true
        delegate?.transporterStart(self)
        executeNextItem()
    }
    
    private func executeNextItem() {
        if commandQueue.count == 0 {
            // complete
            NSLog("[TP] finish work")
            working = false
            delegate?.transporterFinished(self)
            return
        }
        let item = commandQueue.removeFirst()
        let env = environment
        let executor: CommandExecutor = {
            if item.command == .Install {
                return CommandExecutor.deployCommandExecutor(environment: env, package: item.package, device: item.device)
            }
            else if item.command == .Uninstall {
                return CommandExecutor.uninstallCommandExecutor(environment: env, package: item.package, device: item.device)
            }
            preconditionFailure("Missing command implementation")
        }()
        workingExecutor = executor
        workingExecutorDelegate = TransporterCommandExecutorDelegate(device: item.device, completionHandler: { code in
            DispatchQueue.main.async { [weak self] in
                item.device.appendLog(string: "command finished")
                guard let sself = self else { return }
                item.device.status = (code == 0) ? .Complete : .Error
                sself.workingExecutor = nil
                sself.workingExecutorDelegate = nil
                sself.executeNextItem()
            }
        })
        executor.delegate = workingExecutorDelegate
        item.device.status = .Transporting
        item.device.appendLog(string: "command run \(executor.launchPath) \(executor.arguments.joined(separator: " "))")
        executor.run()
    }
}

fileprivate enum TransporterCommand {
    case Install
    case Uninstall
}

fileprivate class TransporterQueueItem {
    let command: TransporterCommand
    let device: Device
    let package: AppPackage
    
    init(command: TransporterCommand, package: AppPackage, device: Device) {
        self.command = command
        self.package = package
        self.device = device
    }
}

fileprivate class TransporterCommandExecutorDelegate: NSObject, CommandExecutorDelegate {
    
    let device: Device
    var completionHandler: ((Int) -> ())?
    
    init(device: Device, completionHandler: ((Int) -> ())?) {
        self.device = device
        self.completionHandler = completionHandler
        super.init()
    }
    
    func commandExecutor(_: CommandExecutor, receiveStandardInput input: String) {
        self.device.appendLog(string: input)
    }
    
    func commandExecutor(_: CommandExecutor, receiveStandardError input: String) {
        self.device.appendLog(string: input)
    }
    
    func commandExecutor(_: CommandExecutor, processTerminated statusCode: Int) {
        if statusCode != 0 {
            self.device.appendLog(string: "Program exited with code \(statusCode)")
        }
        if let handler = completionHandler {
            handler(statusCode)
            completionHandler = nil
        }
    }
}
