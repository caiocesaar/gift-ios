//
//  LoginViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 08/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: LoadingButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.layer.cornerRadius = 5
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = UIColor.black.cgColor
        
        emailTF.text = "caiocs93@gmail.com"
        passTF.text = "123456"
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.showMainScreen(user: user, animated: false)
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.isNavigationBarHidden = false
    }
    
    func dismissKeyboard() -> Void{
        self.view.endEditing(true)
    }
    
    func removeListener() {
        if let handle = handle { Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func showMainScreen(user: User?, animated: Bool = true) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {return}
        present(vc, animated: animated)
    }
    
    func performUserChange(user: User?) {
        guard let user = user else {return}
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = emailTF.text
        changeRequest.commitChanges { (error) in
            if error != nil {
                print(error!)
            }
            self.showMainScreen(user: user, animated: true)
        }
    }

    
    func validateFields() -> Bool {
        
        if (self.emailTF.text == "") {
            showAlert(title: "Ops!",message: "Preencha o campo e-mail")
            return false
        }
        
        if (self.passTF.text?.count ?? 0 < 6) {
            showAlert(title: "Ops!",message: "Senha precisa ter no mínimo 6 dígitos")
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
    
    func showAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapView(_ sender: Any) {
        dismissKeyboard()
    }
    
    @IBAction func login(_ sender: Any) {
        
        if (validateFields()) {

            removeListener()
            self.btnLogin.showLoading()
            
            Auth.auth().signIn(withEmail: emailTF.text!, password: passTF.text!) { (result, error) in
                if error == nil {
                    self.performUserChange(user: result?.user)
                } else {
                    self.btnLogin.hideLoading()
                    print(error!) //criar um alert pra mostrar que deu erro
                }
            }
        }
        
    }

}
