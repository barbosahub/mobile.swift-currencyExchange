//
//  ViewModel.swift
//  currencyConverter
//
//  Created by Rui Barbosa da Silva Junior on 09/10/22.
//

import UIKit

class ViewModel {
    
    
    public var currencySymbol: CurrencySymbol?
    public var listCurrencySymbol:[String] = [""]

    public var currencyResult: CurrencyResult?

    public var numberOfRows: Int{
        return self.listCurrencySymbol.count
    }
    
    public func loadCurrency(indexPath: IndexPath) -> String{
        return self.listCurrencySymbol[indexPath.row]
    }
    
    
    public func filterSymbol(){
        if (self.currencySymbol?.symbols) != nil {
            self.listCurrencySymbol = self.currencySymbol!.symbols.map { "\($0.key)" }
        }
  
        print(self.listCurrencySymbol)
    }
}
