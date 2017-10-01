//
//  AboutViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/1/17.
//  Copyright © 2017 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
