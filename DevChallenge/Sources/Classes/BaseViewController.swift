//
//  BaseViewController.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    
    func showHUD() {
        self.startAnimating(type: .circleStrokeSpin)
    }
    
    func hideHUD() {
        self.stopAnimating()
    }
    
    func showAlert(_ title: String? = nil, text: String) {
        UIAlertController.show(title, text: text, viewController: self)
    }
    
}
