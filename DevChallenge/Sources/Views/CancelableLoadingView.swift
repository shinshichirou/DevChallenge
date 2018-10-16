//
//  CancelableLoadingView.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol CancelableLoadingViewDelegate {
    func canceled()
}

class CancelableLoadingView: UIView {
    
    private var indicatorView: NVActivityIndicatorView!
    private var tapGesture: UITapGestureRecognizer!
    private var helpLabel: UILabel!
    
    var delegate: CancelableLoadingViewDelegate?
    
    init(delegate: CancelableLoadingViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.alpha = 0
        
        // Indicator view
        let indicatorFrame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicatorView = NVActivityIndicatorView(frame: indicatorFrame,
                                                type: .circleStrokeSpin,
                                                color: .white)
        self.addSubview(indicatorView)
        
        // Tap gesture
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(closeByTouch))
        self.addGestureRecognizer(tapGesture)
        
        // Help label
        let labelFrame = CGRect(x: 0, y: 0, width: 300, height: 30)
        helpLabel = UILabel(frame: labelFrame)
        helpLabel.text = "Touch to cancel"
        helpLabel.textAlignment = .center
        helpLabel.font = UIFont.systemFont(ofSize: 24.0)
        helpLabel.alpha = 0
        helpLabel.textColor = .white
        self.addSubview(helpLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = center
        let helpLabelYDelta = CGFloat(100.0)
        helpLabel.center = CGPoint(x: center.x,
                                   y: center.y + helpLabelYDelta)
    }
    
    func showIn(_ view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
        indicatorView.startAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }) { (done) in
            self.activateHelpLabel()
        }
    }
    
    private func activateHelpLabel() {
        UIView.animate(withDuration: 1.0, animations: {
            self.helpLabel.alpha = 1.0
        }) { (done) in
            self.perform(#selector(self.hideHelpLabel), with: nil, afterDelay: 1.0)
        }
    }
    
    @objc private func hideHelpLabel() {
        UIView.animate(withDuration: 1.0) {
            self.helpLabel.alpha = 0.0
        }
    }
    
    @objc private func closeByTouch() {
        if let del = delegate {
            del.canceled()
        }
        close()
    }
    
    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (done) in
            self.indicatorView.stopAnimating()
            self.removeFromSuperview()
        }
    }
    
}
