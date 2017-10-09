//
//  LicenseViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 10/1/17.
//  Copyright © 2017 Nobuhiro Ito.
//
//  This file is part of TransporterPad. Licensed in GPLv3.
//

import Cocoa
import WebKit

class LicenseViewController: NSViewController {

    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var containerView: NSView!
    var webView: WKWebView!
    
    var displayFile: String? {
        didSet {
            if webView != nil {
                loadPage()
            }
        }
    }
    
    deinit {
        webView = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView.init(frame: containerView.bounds)
        containerView.addSubview(webView)
        containerView.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: webView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: webView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: webView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: webView, attribute: .trailing, multiplier: 1, constant: 0),
            ])
        loadPage()
    }
    
    @IBAction func okTapped(_ sender: Any) {
        dismissViewController(self)
    }
    
    func loadPage() {
        guard let fileName = displayFile,
            let resourceURL = Bundle.main.resourceURL
            else { return }
        let fileURL = resourceURL.appendingPathComponent(fileName)
        let str = (try? String.init(contentsOf: fileURL)) ?? ""
        webView.loadHTMLString(str, baseURL: resourceURL)
    }
}
