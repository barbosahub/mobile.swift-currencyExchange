//
//  ViewController.swift
//  currencyConverter
//
//  Created by Rui Barbosa da Silva Junior on 09/10/22.
//

import UIKit
import Foundation
import AutocompleteField
import CurrencyFormatter



class ViewController: UIViewController {
  
    @IBOutlet weak var fieldFrom: AutocompleteField!
    @IBOutlet weak var fieldTo: AutocompleteField!
    @IBOutlet weak var fieldAmount: UITextField!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var btnExchange: UIImageView!

    
    
    let viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValues()
       
    }
    
    private func initValues(){
        self.getSymbols()
    
        self.fieldFrom.suggestions = viewModel.listCurrencySymbol
        self.fieldTo.suggestions = viewModel.listCurrencySymbol
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedMe))
        btnExchange.addGestureRecognizer(tap)
        btnExchange.isUserInteractionEnabled = true
        
    }
    
    @objc func tappedMe(){
        let strFrom: String = self.fieldFrom.text!
        let strTo: String = self.fieldTo.text!
        let amount = Double((self.fieldAmount.text! as NSString).doubleValue)
        
        getConvert(from: strFrom, to: strTo, amount: amount)
    }
        
    private func getSymbols(){
        
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/fixer/symbols"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("2hTba6m2jWGHHEQ1K7ZoRRaNaLVv4Fd9", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
    
            do{
                self.viewModel.currencySymbol = try JSONDecoder().decode(CurrencySymbol.self, from: data)
                self.viewModel.filterSymbol()
                }catch let error{
                print(error)
            }
            
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        
    }
    

    private func getConvert(from: String, to: String, amount: Double){
        var textResult = ""
        var textRate = ""
      
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("2hTba6m2jWGHHEQ1K7ZoRRaNaLVv4Fd9", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
        
            
            do{
                self.viewModel.currencyResult = try JSONDecoder().decode(CurrencyResult.self, from: data)
        
                let info: Info = self.viewModel.currencyResult!.info
                let result = self.viewModel.currencyResult!.result
                let formattedRate = String(format: "%.2f", info.rate)
                let formattedResult = String(format: "%.2f", result)
                let formattedAmount = String(format: "%.2f", amount)
                let text = "\(formattedAmount) \(from) = \(formattedResult) \(to)"
                
                textResult = "1 \(from) = \(formattedRate) \(to)"
                textRate = text
                
            }catch let error{
                print(error)
            }
    
        
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        self.rate.text = textResult
        self.value.text = textRate
    }
    

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        // fill out the rest when user hits return
        let textField = tf as! AutocompleteField
        textField.text = textField.suggestion
        textField.resignFirstResponder()

        return true
    }
}


