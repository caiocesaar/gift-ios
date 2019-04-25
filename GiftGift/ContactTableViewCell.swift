//
//  ContactTableViewCell.swift
//  GiftGift
//
//  Created by Caio Cesar on 05/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleContact: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(name: String){
        self.titleContact.text = name
    }
    
    
    
}
