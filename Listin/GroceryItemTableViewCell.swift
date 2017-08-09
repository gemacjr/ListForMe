//
//  GroceryItemTableViewCell.swift
//  Listin
//
//  Created by Ed McCormic on 7/16/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit

class GroceryItemTableViewCell: ShoppingItemTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantityLabel.isHidden = true
        self.quantityBackgroundView.isHidden = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func bindData(item: GroceryItem){
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        
        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.priceLabel.text = "\(currency) \(String(format: "%.2f", item.price))"
        
        
        if item.image != "" {
            imageFromData(pictureData: item.image, withBlock: { (image) in
                
                
                self.itemImageView.image = image!.circleMasked
            })
        }else {
            
            let image = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
            self.itemImageView.image = image.circleMasked
            
        }
    }

}
