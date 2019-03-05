//
//  APICryptoManager.swift
//  CryptoRateApp
//
//  Created by Shmygovskii Ivan on 05.03.19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import Foundation

struct Currencies {
    let input: String
    let output: String
}

enum RateType: FinalURLPoint {
    case Current(apiKey: String, currencies: Currencies)
    
    var baseURL: URL {
        return URL(string: "https://api.cryptonator.com")!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey, let currencies):
            return "/\(apiKey)/ticker/\(currencies.input)-\(currencies.output)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class APICryptoManager: APIManager {
    
    let  sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    let apiKey: String
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentCryptoRateWith(currencies: Currencies, completionHandler: @escaping (APIResult<CurrentCryptoRate>)-> Void) {
        let request = RateType.Current(apiKey: self.apiKey, currencies: currencies).request
        
        fetch(request: request, parse: { (json) -> CurrentCryptoRate? in
            if let dictionary = json["ticker"] as? [String: AnyObject] {
                return CurrentCryptoRate(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
    }
    
    
    
    
}
