//
//  TermsAndConditionsViewController.swift
//  Neura Swift Sample App
//
//  Created by Neura on 08/04/2018.
//  Copyright © 2018 beauNeura. All rights reserved.
//

import Foundation
import UIKit


class TermsAndConditionsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    var urlStr = ""
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let url = URL(string: self.urlStr)
        self.webView.loadRequest(URLRequest(url:url!))
    }
}
