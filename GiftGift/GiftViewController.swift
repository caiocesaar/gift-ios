//
//  GiftViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 24/05/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GiftViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var placeTF: UITextField!
    
    var giftItem: Gift?
    
    let collection = "presentes"
    var firestoreListener: ListenerRegistration!
    var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        var firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gift = giftItem {
            nameTF.text = gift.name
            valueTF.text = "\(gift.value ?? 0.0)"
            placeTF.text = gift.place
        }
        
    }

    
    func showAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func save(gift: Gift){
        
        let data: [String: Any] = [
            "name": gift.name,
            "place": gift.place,
            "value": gift.value,
        ]
        
        if gift.id?.isEmpty ?? true {
            
            firestore.collection(collection).addDocument(data: data) { (error) in
                if error != nil {
                    print(error)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        } else {
            firestore.collection(collection).document(gift.id ?? "").updateData(data) { (error) in
                if error != nil {
                    print(error)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }

    @IBAction func submit(_ sender: Any) {
        
        guard let name = nameTF.text, name != "", let value = valueTF.text, value != "", let place = placeTF.text, place != "" else {
            showAlert(title: "Erro", message: "Preencha todos os campos")
            return
        }
        
        var item = giftItem ?? Gift()
        item.name = name
        item.value = Float(value)
        item.place = place
        
        print(item)
        
        save(gift: item)
        
    
        
    }
    
    func dismissKeyboard() -> Void{
        self.view.endEditing(true)
    }
    
    @IBAction func didTapView(_ sender: Any) {
        dismissKeyboard()
    }
    
    
}
