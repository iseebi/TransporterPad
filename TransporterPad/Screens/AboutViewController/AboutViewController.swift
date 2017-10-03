//
//  AboutViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/1/17.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    var versionString: String? {
        willSet {
            willChangeValue(forKey: "versionString")
        }
        didSet {
            didChangeValue(forKey: "versionString")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let infoDict = Bundle.main.infoDictionary,
            let version = infoDict["CFBundleShortVersionString"] as? String {
            versionString = String(format:"Version %@", version)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let licenseViewController = segue.destinationController as? LicenseViewController else { return }
        if segue.identifier == "showAcknowledgements" {
            licenseViewController.displayFile = "acknowledgements.html"
        }
        else if segue.identifier == "showLicense" {
            licenseViewController.displayFile = "license.html"
        }
        else {
            preconditionFailure("Unknown identifier")
        }
    }
}
