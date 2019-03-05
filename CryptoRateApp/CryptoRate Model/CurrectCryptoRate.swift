//
//  CurrectCryptoRate.swift
//  CryptoRateApp
//
//  Created by Shmygovskii Ivan on 05.03.19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import Foundation
import UIKit

struct CurrentCryptoRate {
    let base: UIImage
    let price: String
    let change: String
}

extension CurrentCryptoRate: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let base = JSON["base"] as? String,
            let price = JSON["price"] as? String,
            let change = JSON["change"] as? String else {
                return nil
        }
        
        let icon = CryptoIconManager(rawValue: base).image
        
        self.price = price
        self.change = change
        self.base = icon
    }
    
    
}

extension CurrentCryptoRate {
    var priceString: String {
        return "\(price)$"
    }
    
    var changeString: String {
        return "\(change)$"
    }
    
}
