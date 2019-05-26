//
//  MainTabBarViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 25/05/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated:true);
    }
    
}
