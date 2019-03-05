//
//  CryptoIconManager.swift
//  CryptoRateApp
//
//  Created by Shmygovskii Ivan on 05.03.19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import Foundation
import UIKit

enum CryptoIconManager: String {
    
    case BTC  = "BTC image"
    case ETH = "ETH shadow"
    case LTC = "LTC shadow"
    
    init(rawValue: String) {
        switch rawValue {
        case "BTC image": self = .BTC
        case "ETH shadow": self = .ETH
        case "LTC shadow": self = .LTC
        default: self = .BTC
        }
    }
    
}

extension CryptoIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
