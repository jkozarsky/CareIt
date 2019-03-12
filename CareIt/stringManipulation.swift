//
//  stringManipulation.swift
//  CareIt
//
//  Created by Prince Geutler (student LM) on 2/27/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//


import Foundation


class StringManipulation{
    
    static func getIngredientsArray(_ foodString: String) -> [String] {
        
        var fullNameArr = foodString.components(separatedBy: " ")
        var ingredients = [String]()
        
        for i in 0 ..< (fullNameArr.count) {
            
            if fullNameArr[i].range(of: ",") == nil && i < (fullNameArr.count-1) && fullNameArr[i+1].range(of: "[" ) == nil && fullNameArr[i+1].range(of: "(") == nil {
                
                fullNameArr[i+1] = fullNameArr[i] + " " + fullNameArr[i+1]
            }
            else {
                ingredients.append(fullNameArr[i])
            }
        }
        
        //this is hella ugly so if anyone wants to work with regexes to redo this, go ahead
        ingredients = ingredients.map {element in
            return element.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "CONTAINS ONE OR MORE OF THE FOLLOWING: ", with: "").replacingOccurrences(of: "-", with: "")
        }
        
        return ingredients
    }
}
