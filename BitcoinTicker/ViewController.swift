//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencySymbolLabel.text = currencyArray[row]
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinPrice(url: finalURL)
    }
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var Box: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        currencyPicker.layer.cornerRadius = 20
        currencyPicker.layer.masksToBounds = false
        currencyPicker.layer.shadowColor = UIColor.black.cgColor
        currencyPicker.layer.shadowOpacity = 0.5
        currencyPicker.layer.shadowOffset = CGSize(width: -1, height: 1)
        currencyPicker.layer.shadowRadius = 5
        
        Box.layer.cornerRadius = 20
        Box.layer.masksToBounds = false
        Box.layer.shadowColor = UIColor.black.cgColor
        Box.layer.shadowOpacity = 0.5
        Box.layer.shadowOffset = CGSize(width: -1, height: 1)
        Box.layer.shadowRadius = 5
        
    }
    
  
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPrice(url: String){
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Sucess we got Bitcoin data")
                
                let bitcoinPriceJSON : JSON = JSON(response.result.value!)
                
                self.updateBitcoinPriceData(json: bitcoinPriceJSON)
                
            }
            
            else if response.result.isFailure {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
                
            }
        }
    }

    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/

    
    func updateBitcoinPriceData(json: JSON) {
        if let priceResult = json["averages"]["day"].double {
            bitcoinPriceLabel.text = "\(priceResult)"
        }
        
        else {
            bitcoinPriceLabel.text = "Data currently unavailable"
        }
    }
//




}

