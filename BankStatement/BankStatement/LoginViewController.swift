//
//  LoginViewController.swift
//  BankStatement
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    override func loadView() { view = LoginView(frame: UIScreen.main.bounds) }
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancellable = (view as? LoginView)?.sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { (model) in
            print(model)
        })
    }

}
