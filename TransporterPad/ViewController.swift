//
//  ViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var dragTargetView: DragTargetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragTargetView.delegate = self
    }


}

extension ViewController : DragTargetViewDelegate {

    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String) {
        NSLog("Remote file:%@", fileName)
    }
    
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String) {
        NSLog("Local file:%@", fileName)
    }
    
}
