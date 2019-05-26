//
//  GiftTableViewCell.swift
//  GiftGift
//
//  Created by Caio Cesar on 24/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(gift: Gift) {
        
        titleLabel.text = gift.name ?? ""
        localLabel.text = gift.place
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        if let formattedTipAmount = formatter.string(from: gift.value as NSNumber? ?? 0 as NSNumber) {
            priceLabel.text = "\(formattedTipAmount)"
        }
        
    }

}
