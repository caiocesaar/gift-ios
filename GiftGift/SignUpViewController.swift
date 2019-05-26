//
//  SignUpViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 08/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var btnSignUp: LoadingButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSignUp.layer.cornerRadius = 5
        self.btnSignUp.layer.borderWidth = 1
        self.btnSignUp.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        
        if (validateFields()){
            let email = emailTF.text ?? ""
            let password = passwordTF.text ?? ""
            
            self.btnSignUp.showLoading()
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error == nil {
                    self.showLoginScreen()
                } else {
                    self.showAlert(title: "Ops!",message: "Houve algum erro! Tente novamente")
                    self.btnSignUp.hideLoading()
                    print(error)
                }
            }
        }
        
    }
    
    func showAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> Bool {
        
        if (self.nameTF.text == "") {
            showAlert(title: "Ops!",message: "Preencha o campo nome")
            return false
        }
        
        if (self.emailTF.text == "") {
            showAlert(title: "Ops!",message: "Preencha o campo e-mail")
            return false
        }
        
        if (self.passwordTF.text == "") {
            showAlert(title: "Ops!",message: "Preencha o campo senha")
            return false
        }
        
        if (self.passwordTF.text?.count ?? 0 < 6) {
            showAlert(title: "Ops!",message: "Senha precisa ter no mínimo 6 dígitos")
            return false
        }
        
        if (self.confirmPasswordTF.text == "") {
            showAlert(title: "Ops!",message: "Preencha o campo de confirmação de senha")
            return false
        }
        
        if (self.passwordTF.text != self.confirmPasswordTF.text) {
            showAlert(title: "Ops!",message: "Senha e confirmação de senha não conferem")
            return false
        }
        
        if (!isValidEmail(email: self.emailTF.text ?? "")){
            showAlert(title: "Ops!",message: "Preencha o e-mail corretamente")
            return false
        }
        
        
        return true
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func showLoginScreen() {
        self.dismiss(animated: true, completion:  nil)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        showLoginScreen()
    }
    

}
