//
//  InputViewController.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var lowerBoundField: UITextField!
    @IBOutlet weak var upperBoundField: UITextField!
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            commentsButton.isEnabled = false
        }
    }
    
    private var loadingView: CancelableLoadingView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHidingKeyboard()
    }
    
    // MARK: - Actions
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        showLoading()
        let randomTime = TimeInterval(arc4random_uniform(3) + 3)
        perform(#selector(openComments), with: nil, afterDelay: randomTime)
    }
    
    @IBAction func textFieldsEditChanged(_ sender: UITextField) {
        checkFieldsValues()
    }
    
    private func showLoading() {
        if let nav = navigationController {
            loadingView = CancelableLoadingView(delegate: self)
            loadingView.showIn(nav.view)
        }
    }
    
    // Delayed selector.
    @objc private func openComments() {
        loadingView.close()
        self.performSegue(withIdentifier: SegueIdentifier.toComments, sender: self)
    }
    
    // Get the values for bounds.
    private func bounds() -> Bounds? {
        if let lowerBoundText = lowerBoundField.text,
            let upperBoundText = upperBoundField.text,
            let lower = Int(lowerBoundText),
            let upper = Int(upperBoundText) {
            return Bounds(upper: upper,
                          lower: lower)
        }
        return nil
    }
    
    // Checking if field values are correct.
    private func checkFieldsValues() {
        if let bounds = bounds(),
            bounds.lower < bounds.upper {
            commentsButton.isEnabled = true
        } else {
            commentsButton.isEnabled = false
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toComments {
            if let listViewController = segue.destination as? ListViewController,
            let bounds = bounds() {
                listViewController.bounds = bounds
            }
        }
    }

}

extension InputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case lowerBoundField:
            upperBoundField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: string)
        return CharacterSet.decimalDigits.isSuperset(of: characterSet)
    }
    
}

extension InputViewController: CancelableLoadingViewDelegate {
    
    func canceled() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
}
