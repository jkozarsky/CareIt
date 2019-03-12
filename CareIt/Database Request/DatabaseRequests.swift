//
//  DatabaseRequests.swift
//  CareIt
//
//  Created by William Londergan (student LM) on 1/16/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import Foundation

class DatabaseRequests {
    //doesn't work
    var result: Food?
    var error: String?
    var barcodeString: String
    var currentlyProcessing = false
    
    func request(beforeLoading: () -> Void, afterLoading: @escaping () -> Void) {
        beforeLoading()
        currentlyProcessing = true
       
        let urlString = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(barcodeString)&sort=n&max=25&offset=0&api_key=QeUnhmFwm0AZn3JpYHBwTd1cwx5LMk1zbDwGhgDJ"
    
        guard let url = URL(string: urlString) else {
            self.internetConnectionError()
            
            DispatchQueue.main.async(execute: afterLoading)
            return
        }
      
        URLSession.shared.dataTask(with: url) { (data, request, error) in
            
            guard let data = data else {
                self.internetConnectionError()
                
                DispatchQueue.main.async(execute: afterLoading)
                return
            }
            
            do{
                
                let res = try JSONDecoder().decode(FoodIDDatabaseRequest.self, from: data)
              
                let ndbno = res.list.item[0].ndbno
                let ndbString = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=\(ndbno)&type=f&format=json&api_key=QeUnhmFwm0AZn3JpYHBwTd1cwx5LMk1zbDwGhgDJ"
    
                guard let url = URL(string: ndbString) else {
                    self.internetConnectionError()
                    
                    DispatchQueue.main.async(execute: afterLoading)
                    return
                }
    
                //second request inside the first
                URLSession.shared.dataTask(with: url) {
                    (data, request, error) in
                    guard let data = data else {self.internetConnectionError(); afterLoading(); return}
                    do {
                        let res = try JSONDecoder().decode(NDBDatabaseRequest.self, from: data)
                        self.result = res.foods.first?.food
                        
                        DispatchQueue.main.async(execute: afterLoading)
                    } catch {
                        self.decodingError()
                        
                        DispatchQueue.main.async(execute: afterLoading)
                        return
                    }
    
                }.resume()
    
            } catch {
                self.decodingError()
                
                DispatchQueue.main.async(execute: afterLoading)
                return
            }
            }.resume()
        
        }
    
    init(barcodeString: String) {
        self.barcodeString = barcodeString
    }
    
    func internetConnectionError() {
        self.error = "An error occurred. Please check your internet connection."
    }
    
    func decodingError() {
        self.error = "An error occurred. The barcode was not found in the database."
    }

}
