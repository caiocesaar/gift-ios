//
//  GiftTableViewCell.swift
//  GiftGift
//
//  Created by Caio Cesar on 24/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {

    @IBOutlet weak var imageGift: UIImageView!
    @IBOutlet weak var titleGift: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(title: String) {
        self.titleGift.text = title ?? ""
    }

}
