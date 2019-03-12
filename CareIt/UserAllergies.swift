//
//  UserAllergies.swift
//  CareIt
//
//  Created by Jason Kozarsky (student LM) on 3/5/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserAllergies {
    
    static func userIsAllergicTo(_ food: Food) -> [String]?{
        var userInfo: [String: Any]? = [:]
        var allergies: [String] = []
        
        guard let uid = Auth.auth().currentUser?.uid else {return nil}
        let databaseRef = Database.database().reference().child("users\(uid)")
        
        databaseRef.observeSingleEvent(of: .value, with: {snapshot in
            userInfo = snapshot.value as? [String: Any] ?? [:]
        })
        
        if let userInfo = userInfo{
            allergies = userInfo["Allergies"] as! [String]
        }
        
        var conflictingAllergies: [String] = []
        
        let ingredientsList: [String] = StringManipulation.getIngredientsArray(food.ing.desc)
        
        for allergy in allergies{
            for ingredient in ingredientsList{
                if ingredient.lowercased().contains(allergy.lowercased()){
                    conflictingAllergies.append(ingredient)
                }
            }
        }
        
        return conflictingAllergies
    }
    
}

