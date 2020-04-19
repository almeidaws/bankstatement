//
//  String+isValidPassword.swift
//  BankStatement
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

extension String {
    func isValidPassword() -> Bool {
        return self.containsAtLeastOneUppercaseLetter() &&
            self.containsAtLeastOneSpecialCharacter() &&
            self.containsAtLeastOneAlphanumericCharacter()
    }
    
    private func containsAtLeastOneAlphanumericCharacter() -> Bool {
        let regex = ".*[0-9a-zA-Z]+.*"

        let pred = NSPredicate(format:"SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    private func containsAtLeastOneSpecialCharacter() -> Bool {
        let regex = ".*[!@#$%^&*()_+=-]+.*"

        let pred = NSPredicate(format:"SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    private func containsAtLeastOneUppercaseLetter() -> Bool {
        let regex = ".*[A-Z]+.*"

        let pred = NSPredicate(format:"SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
}
