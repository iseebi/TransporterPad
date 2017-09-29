//
//  Transporter.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/29.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

protocol TransporterDelegate: class {
    func transporterStart(_: Transporter)
    func transporterFinished(_: Transporter)
}

class Transporter: NSObject {

    let environment: Environment
    var delegate: TransporterDelegate?
    
    fileprivate var commandQueue: [TransporterQueueItem] = []
    
    init(environment: Environment) {
        self.environment = environment
        super.init()
    }
    
    func transport(package: AppPackage, targetDevices: [Device], reInstall: Bool) {
        let devices = targetDevices.filter { d in d.platform == package.platform }
        
        // TODO execution lock
        
        commandQueue = []
        
        for device in devices {
            if reInstall {
                commandQueue.append(TransporterQueueItem(command: .Uninstall, package: package, device: device))
            }
            commandQueue.append(TransporterQueueItem(command: .Install, package: package, device: device))
        }
        
        // begin
        
        executeNextItem()
    }
    
    private func executeNextItem() {
        if commandQueue.count == 0 {
            // complete
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
        executor.delegate = TransporterCommandExecutorDelegate(device: item.device, completionHandler: { [weak self] code in
            guard let sself = self else { return }
            item.device.status = (code == 0) ? .Complete : .Error
            sself.executeNextItem()
        })
        item.device.status = .Transporting
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
        self.device.log.append(input)
    }
    
    func commandExecutor(_: CommandExecutor, receiveStandardError input: String) {
        self.device.log.append(input)
    }
    
    func commandExecutor(_: CommandExecutor, processTerminated statusCode: Int) {
        if statusCode != 0 {
            self.device.log.append("\nProgram exited with code \(statusCode)")
        }
        if let handler = completionHandler {
            handler(statusCode)
            completionHandler = nil
        }
    }
}
