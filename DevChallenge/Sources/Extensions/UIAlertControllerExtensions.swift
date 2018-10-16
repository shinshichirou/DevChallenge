//
//  UIAlertControllerExtensions.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    @objc class func show(_ title: String? = nil, text: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title,
                                                message: text,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true) { }
    }
    
}

