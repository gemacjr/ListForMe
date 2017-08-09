//
//  SwipeTableViewHelpers.swift
//  Listin
//
//  Created by Ed McCormic on 7/15/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import Foundation
import UIKit

enum ActionDescriptor {
    case buy, returnPurchase, trash
    
    func title() -> String? {
        
        switch self {
        case .buy: return "Buy"
        case .returnPurchase: return "Return"
        case .trash: return "Trash"
            
        }
    }
    
    func image() -> UIImage? {
        
        let name: String
        switch self {
        case .buy:
            name = "BuyFilled"
        case .returnPurchase:
            name = "ReturnFilled"
        case .trash:
            name = "Trash"
            
        }
        
        return UIImage(named: name)
    }
    
    var color: UIColor {
        
        switch self {
        case .buy, .returnPurchase: return UIColor.green.withAlphaComponent(0.8)
        case .trash: return .red
        }
    }
}

func createSelectedBackgroundView() -> UIView {
    
    let view = UIView()
    view.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    
    return view
}
