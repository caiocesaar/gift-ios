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

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.layer.cornerRadius = 5
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func dismissKeyboard() -> Void{
        self.view.endEditing(true)
    }
    
    func removeListener() {
        if let handle = handle { Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func showMainScreen(user: User?, animated: Bool = true) {
        print("Indo para a próxima tela")
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ContactsTableViewController.self)) else {return}
        navigationController?.pushViewController(vc, animated: animated)
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

    
    @IBAction func didTapView(_ sender: Any) {
        self.dismissKeyboard()
    }
    
    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passTF.text!) { (result, error) in
            
            if error == nil {
                self.performUserChange(user: result?.user)
            } else {
                print(error!) //criar um alert pra mostrar que deu erro
            }
            
        }
        
    }
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        backItem.title = "Voltar"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being
    }
    

}
