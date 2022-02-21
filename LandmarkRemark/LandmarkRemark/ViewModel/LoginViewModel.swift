//
//  LoginViewModel.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 20/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import Foundation

protocol LoginViewModelViewDelegate: class {
    func canSubmitStatusDidChange(_ viewModel: LoginViewModel, status: Bool)
}

class LoginViewModel {
    var delegate: LoginViewModelViewDelegate?
    
    fileprivate var userNameIsValidFormat: Bool = false
    
    var canSubmit: Bool {
        return userNameIsValidFormat
    }
    
    var userName: String = "" {
        didSet {
            if oldValue != userName {
                let oldCanSubmit = canSubmit
                userNameIsValidFormat = validateUserNameAsEmailFormat(userName)
                if canSubmit != oldCanSubmit {
                    self.delegate?.canSubmitStatusDidChange(self, status: canSubmit)
                }
            }
        }
    }
    
    fileprivate func validateUserNameAsEmailFormat(_ userName: String) -> Bool {
        let REGEX: String
        REGEX = ".*[^A-Za-z0-9].*"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: userName)
    }
}
