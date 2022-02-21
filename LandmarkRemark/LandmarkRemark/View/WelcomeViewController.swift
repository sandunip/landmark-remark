//
//  WelcomeViewController.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 19/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private var loginviewmodel = LoginViewModel()
    
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var submitButton : UIButton!
    
    let maxNumCharacters = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        loginviewmodel.delegate = self
        self.userNameTextField.addTarget(self, action: #selector(userNameFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func userNameFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            loginviewmodel.userName = text
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.userNameTextField.text = ""
    }
    
    //MARK: Button click actions
    @IBAction func signIn(_ sender: Any) {
        UserDefaultsManager.setUserName(userName: self.userNameTextField.text!)
        performSegue(withIdentifier: NavigationConstants.Segue.HOMESCREEN_SEGUE, sender: nil)
    }
}

extension WelcomeViewController : UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let newLength = textField.text!.count + string.count - range.length
        return newLength <= maxNumCharacters
    }
}

extension WelcomeViewController : LoginViewModelViewDelegate {
    func canSubmitStatusDidChange(_ viewModel: LoginViewModel, status: Bool) {
        submitButton.isEnabled = true
        if status {
            submitButton.isEnabled = false
        }
    }
}
