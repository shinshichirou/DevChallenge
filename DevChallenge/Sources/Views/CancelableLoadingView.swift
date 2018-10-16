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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = center
        let helpLabelYDelta = CGFloat(100.0)
        helpLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 32)
        helpLabel.center = CGPoint(x: center.x,
                                   y: center.y + helpLabelYDelta)
    }
    
    // MARK: - Configure views
    
    private func setup() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.alpha = 0
        
        setupIndicator()
        setupTap()
        setupHelpLabel()
    }
    
    private func setupIndicator() {
        let indicatorFrame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicatorView = NVActivityIndicatorView(frame: indicatorFrame,
                                                type: .circleStrokeSpin,
                                                color: .white)
        self.addSubview(indicatorView)
    }
    
    private func setupTap() {
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(closeByTouch))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupHelpLabel() {
        helpLabel = UILabel(frame: CGRect.zero)
        helpLabel.text = "Touch to cancel"
        helpLabel.textAlignment = .center
        helpLabel.font = UIFont.systemFont(ofSize: 24.0)
        helpLabel.alpha = 0
        helpLabel.textColor = .white
        self.addSubview(helpLabel)
    }
    
    // MARK: - Public actions
    
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
    
    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (done) in
            self.indicatorView.stopAnimating()
            self.removeFromSuperview()
        }
    }
    
    // MARK: Private actions
    
    private func activateHelpLabel() {
        UIView.animate(withDuration: 1.0, animations: {
            self.helpLabel.alpha = 1.0
        }) { (done) in
            self.perform(#selector(self.hideHelpLabel),
                         with: nil,
                         afterDelay: 1.0)
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
    
}
