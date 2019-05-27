//
//  SettingsViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 26/05/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var switchButton: UISwitch!
    let settings = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchButton.isOn = settings.bool(forKey: "dark")
    }
    
    @IBAction func didTapUpdate(_ sender: Any) {
        settings.set(switchButton.isOn, forKey: "dark")
        showAlert(title: "OK!", message: "Alterado com sucesso")
    }
    
    func showAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
