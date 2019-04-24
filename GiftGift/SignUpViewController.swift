//
//  SignUpViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 08/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.btnSignUp.layer.cornerRadius = 5
        self.btnSignUp.layer.borderWidth = 1
        self.btnSignUp.layer.borderColor = UIColor.black.cgColor
        
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        
        if (self.validateFields()){
            
            if (self.nameTF.text == "") {
                self.showAlertValidation()
            }
            
        }
        
        //auth firebase
        
    }
    
    func showAlertValidation() -> Void {
        let alert = UIAlertController(title: "Erro", message: "Preencha todos os campos", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Erro", style: .default, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> Bool {
        
        
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
