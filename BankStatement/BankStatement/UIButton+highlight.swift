//
//  UIButton+highlight.swift
//  BankStatement
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

extension UIButton {
    
    enum HighlightEffect {
        case spring
    }
    
    func highlight(mode: HighlightEffect) {
        switch mode {
        case .spring:
            self.addTarget(self, action: #selector(handleTouchDown(_:)), for: .touchDown)
            self.addTarget(self, action: #selector(handleTouchUp(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func handleTouchUp(_ button: UIButton) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            button.restoreSize()
        }, completion: nil)
    }
    
    @objc private func handleTouchDown(_ button: UIButton) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            button.decreaseSize()
        }, completion: nil)
    }
    
    private func decreaseSize() {
        self.transform = .init(scaleX: 0.95, y: 0.95)
    }
    
    private func restoreSize() {
        self.transform = .identity
    }
}
