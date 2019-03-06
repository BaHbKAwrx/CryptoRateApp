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
    var currencies = Currencies(input: "BTC", output: "USD")
    let userDef = UserDefaults.standard
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRateChangeRounded()
        
        settingRateDefaultValues()
        
        getCurrentRateData()
        
    }
    
    //MARK: - Methods
    func makeRateChangeRounded() {
        
        rateChangeDollarsLabel.layer.cornerRadius = 10
        rateChangeDollarsLabel.clipsToBounds = true
        rateChangePercentLabel.layer.cornerRadius = 10
        rateChangePercentLabel.clipsToBounds = true
        
    }
    
    func settingRateDefaultValues() {
        
        currentRateButton.setTitle("-", for: .normal)
        rateChangeDollarsLabel.text = "-"
        rateChangePercentLabel.text = "-"
        rateChangeDollarsLabel.backgroundColor = .clear
        rateChangePercentLabel.backgroundColor = .clear
        if userDef.integer(forKey: "Favourite") == currencySegmControl.selectedSegmentIndex {
            isFavouriteButton.setImage(UIImage(named: "Selected star"), for: .normal)
        }
        
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
        
        let priceStringRounded = makeStringRounded(string: currentRate.price, signsAfterDot: 2)
        let changeStringRounded = makeStringRounded(string: currentRate.change, signsAfterDot: 3)
        let changePercentString = "\(Double(changeStringRounded)! / Double(priceStringRounded)! * 100)"
        let changePercentStringRounded = makeStringRounded(string: changePercentString, signsAfterDot: 2)
        
        //Changing rect colors depend from change up or down
        if changeStringRounded.hasPrefix("-") {
            self.rateChangeDollarsLabel.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.4392156863, blue: 0.3647058824, alpha: 1)
        } else {
            self.rateChangeDollarsLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        
        if changePercentStringRounded.hasPrefix("-") {
            self.rateChangePercentLabel.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.4392156863, blue: 0.3647058824, alpha: 1)
        } else {
            self.rateChangePercentLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        
        self.currencyImageView.image = currentRate.base
        self.currentRateButton.setTitle(priceStringRounded + "$", for: .normal)
        self.rateChangeDollarsLabel.text = changeStringRounded + "$"
        self.rateChangePercentLabel.text = changePercentStringRounded + "%"
        
    }
    
    func makeStringRounded(string: String, signsAfterDot signs: Int) -> String {
        
        let stringArr = string.components(separatedBy: ".")
        let index = stringArr[1].index(stringArr[1].startIndex, offsetBy: signs)
        let firstPart = stringArr[0]
        let secondPart = String(stringArr[1].prefix(upTo: index))
        let stringRounded = firstPart + "." + secondPart
        return stringRounded
        
    }

    //MARK: - Button actions
    @IBAction func segmControlValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == userDef.integer(forKey: "Favourite") {
            isFavouriteButton.setImage(UIImage(named: "Selected star"), for: .normal)
        } else {
            isFavouriteButton.setImage(UIImage(named: "Star"), for: .normal)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            currencies = Currencies(input: "BTC", output: "USD")
            refreshRateButton.setImage(UIImage(named: "Bitcoin refresh"), for: .normal)
            getCurrentRateData()
        case 1:
            currencies = Currencies(input: "ETH", output: "USD")
            refreshRateButton.setImage(UIImage(named: "Eth refresh"), for: .normal)
            getCurrentRateData()
        case 2:
            currencies = Currencies(input: "LTC", output: "USD")
            refreshRateButton.setImage(UIImage(named: "Litecoin refresh"), for: .normal)
            getCurrentRateData()
        default:
            break
        }
        
    }
    
    @IBAction func starButtonPushed(_ sender: UIButton) {
        
        userDef.set(currencySegmControl.selectedSegmentIndex, forKey: "Favourite")
        sender.setImage(UIImage(named: "Selected star"), for: .normal)
        
    }
    
    @IBAction func refreshButtonPushed(_ sender: UIButton) {
        
        getCurrentRateData()
        
    }
    
}

