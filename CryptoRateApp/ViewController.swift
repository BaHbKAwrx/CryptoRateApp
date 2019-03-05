//
//  ViewController.swift
//  CryptoRateApp
//
//  Created by Shmygovskii Ivan on 05.03.19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var currencySegmControl: UISegmentedControl!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var isFavouriteButton: UIButton!
    @IBOutlet weak var currentRateButton: UIButton!
    @IBOutlet weak var refreshRateButton: UIButton!
    @IBOutlet weak var rateChangeDollarsLabel: UILabel!
    @IBOutlet weak var rateChangePercentLabel: UILabel!
    
    lazy var cryptoManager = APICryptoManager(apiKey: "api")
    let currencies = Currencies(input: "BTC", output: "USD")
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRateChangeRounded()
        
        getCurrentRateData()
        
    }
    
    //MARK: - Methods
    func makeRateChangeRounded() {
        
        rateChangeDollarsLabel.layer.cornerRadius = 10
        rateChangeDollarsLabel.clipsToBounds = true
        rateChangePercentLabel.layer.cornerRadius = 10
        rateChangePercentLabel.clipsToBounds = true
        
    }
    
    func getCurrentRateData() {
        
        cryptoManager.fetchCurrentCryptoRateWith(currencies: currencies) { (result) in
            
            switch result {
            case .Sucess(let currentRate):
                self.updateUIWith(currentRate: currentRate)
            case .Failure(let error as NSError):
                let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func updateUIWith(currentRate: CurrentCryptoRate) {
        
        self.currentRateButton.setTitle(currentRate.priceString, for: .normal)
        self.rateChangeDollarsLabel.text = currentRate.changeString
        
    }

    //MARK: - Button actions
    @IBAction func segmControlValueChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func starButtonPushed(_ sender: UIButton) {
    }
    
    @IBAction func refreshButtonPushed(_ sender: UIButton) {
    }
    
}

