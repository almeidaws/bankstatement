//
//  LoginView.swift
//  BankStatement
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Stevia
import KeyboardLayoutGuide
import Combine

class LoginView: UIView {
    
    private weak var userTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var loginButton: UIButton!
    
    private let subject = CurrentValueSubject<LoginView.Model, Never>(Model(username: "", password: ""))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViewElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViewElements() {
        let logo = UIImageView(image: #imageLiteral(resourceName: "Logo.png"))
        let user = createUserTextField()
        userTextField = user
        userTextField.delegate = self
        let password = createPasswordTextField()
        passwordTextField = password
        passwordTextField.delegate = self
        let login = createLoginButton()
        loginButton = login
        
        let fieldsContainer = UIView()
        subviews {
            logo
            fieldsContainer.subviews (
                user,
                password
            )
            login
        }
        
        logo
            .width(33.4%)
            .centerHorizontally()
            .top(8.4%)
        logo.Height == 56 % logo.Width
        
        user
            .width(91.2%)
            .top(23.6%)
            .centerHorizontally()
        user.Height == 14.6 % user.Width
            
        
        password
            .width(91.2%)
            .centerHorizontally()
        password.Height == 14.6 % password.Width
        password.Top == user.Bottom + 21
        
        login
            .width(53.9%)
            .height(9.3%)
            .bottom(3.9%)
            .centerHorizontally()
        
        fieldsContainer.Top == logo.Bottom
        fieldsContainer.Bottom == login.Top
        fieldsContainer.fillHorizontally()
        
        login.Bottom == keyboardLayoutGuide.Top - 33
        
        style { appearance in
            appearance.backgroundColor = .white
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let username = userTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let model = Model(username: username, password: password)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            
            if model.isUsernameValid() || model.username.isEmpty {
                self.userTextField.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8862745098, blue: 0.9333333333, alpha: 1)
            } else {
                self.userTextField.layer.borderColor = #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
            }
            
            if model.isPasswordValid() || model.password.isEmpty {
                self.passwordTextField.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8862745098, blue: 0.9333333333, alpha: 1)
            } else {
                self.passwordTextField.layer.borderColor = #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
            }
            
            if model.isValid() {
                self.loginButton.alpha = 1
                self.loginButton.isUserInteractionEnabled = true
            } else {
                self.loginButton.alpha = 0.3
                self.loginButton.isUserInteractionEnabled = false
            }
            
        }, completion: nil)
        
        subject.send(model)
    }
    
    @objc private func handleLogin(_ button: UIButton) {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        subject.send(completion: .finished)
    }
}

extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:break
        }
        return true
    }
}

extension LoginView: Publisher {
    typealias Output = Model
    
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Model == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

extension LoginView {
    private func createLoginButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        button.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        button.highlight(mode: .spring)
        
        return button.style { button in
            button.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.2823529412, blue: 0.9333333333, alpha: 1)
            button.layer.cornerRadius = 4
            button.layer.shadowColor = #colorLiteral(red: 0.231372549, green: 0.2823529412, blue: 0.9333333333, alpha: 1)
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = .init(width: 0, height: 3)
            button.layer.shadowRadius = 6
            button.alpha = 0.3
            button.isUserInteractionEnabled = false
        }
    }
    
    private func createUserTextField() -> UITextField {
        let textField = createTextField()
        textField.placeholder = "User"
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        return textField
    }
    
    private func createPasswordTextField() -> UITextField {
        let textField = createTextField()
        textField.placeholder = "Password"
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        return textField
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField.style { tx in
            tx.borderStyle = .line
            tx.layer.borderWidth = 1
            tx.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8862745098, blue: 0.9333333333, alpha: 1)
            tx.layer.cornerRadius = 4
            tx.layer.masksToBounds = true
            tx.font = UIFont(name: "HelveticaNeue", size: 15)
            tx.leftView = UIView(frame: .init(x: 0, y: 0, width: 13, height: 0))
            tx.leftViewMode = .always
            tx.rightView = UIView(frame: .init(x: 0, y: 0, width: 13, height: 0))
            tx.rightViewMode = .always
        }
    }
}

extension LoginView {
    struct Model {
        let username: String
        let password: String
        
        func isValid() -> Bool {
            return isUsernameValid() && isPasswordValid()
        }
        
        func isPasswordValid() -> Bool {
            return password.isValidPassword()
        }
        
        func isUsernameValid() -> Bool {
            return username.isValidEmail() || username.isValidCPF()
        }
    }
}
