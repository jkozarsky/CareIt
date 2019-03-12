////
////  FoodRequestView.swift
////  CareIt
////
////  Created by William Londergan (student LM) on 3/1/19.
////  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
////
//
//import UIKit
//
//
//class FoodRequestView {
//    let displayView: UIView
//    let food: Food
//
//    init(_ displayView: UIView, food: Food) {
//        self.displayView = displayView
//        self.food = food
//    }
//
//    func setup() {
//
//        let dismissButton = UIButton(type: .custom)
//        dismissButton.backgroundColor = .black
//
//        dismissButton.setTitle("Done", for: .normal)
//        dismissButton.setTitleColor(.white, for: .normal)
//        dismissButton.translatesAutoresizingMaskIntoConstraints = false
//
//        dismissButton.layer.cornerRadius = 8
//        dismissButton.layer.masksToBounds = true
//
//        displayView.addSubview(dismissButton)
//        dismissButton.widthAnchor.constraint(equalTo: displayView.widthAnchor, multiplier: 0.3).isActive = true
//        dismissButton.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
//        dismissButton.heightAnchor.constraint(equalTo: displayView.heightAnchor, multiplier: 0.1).isActive = true
//        dismissButton.bottomAnchor.constraint(equalTo: displayView.bottomAnchor, constant: -10).isActive = true
//        dismissButton.addTarget(displayView, action: #selector(doneButton(_:)), for: .touchUpInside)
//
//        displayView.alpha = 1
//        displayView.backgroundColor = .white //we should probably figure out what color this actually will be
//
//        let foodTitle = UILabel()
//
//        displayView.addSubview(foodTitle)
//
//        foodTitle.translatesAutoresizingMaskIntoConstraints = false
//        foodTitle.topAnchor.constraint(equalTo: displayView.topAnchor, constant: 10).isActive = true
//        foodTitle.widthAnchor.constraint(equalTo: displayView.widthAnchor, constant: -20).isActive = true
//        foodTitle.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
//        foodTitle.contentMode = .center
//
//        foodTitle.font = UIFont(name: "Helvetica Neue", size: 30)
//        foodTitle.text = process(food.desc.name)
//        foodTitle.textAlignment = .center
//
//
//        foodTitle.contentMode = .center
//
//        if let allergies = userAllergic() {
//
//            let warningLabel = UILabel()
//            warningLabel.translatesAutoresizingMaskIntoConstraints = false
//            warningLabel.text = "Unsafe to Eat 💀"
//            warningLabel.font = UIFont(name: "Helvetica Neue", size: 30)
//            warningLabel.backgroundColor = .red
//            warningLabel.textColor = .white
//            displayView.addSubview(warningLabel)
//            warningLabel.topAnchor.constraint(equalTo: foodTitle.bottomAnchor, constant: 20).isActive = true
//            warningLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
//        } else {
//            let okayLabel = UILabel()
//            okayLabel.translatesAutoresizingMaskIntoConstraints = false
//            okayLabel.text = "Safe to Eat 🍴"
//            okayLabel.font = UIFont(name: "Helvetica Neue", size: 30)
//            okayLabel.backgroundColor = .green
//            okayLabel.textColor = .white
//            displayView.addSubview(okayLabel)
//            okayLabel.topAnchor.constraint(equalTo: foodTitle.bottomAnchor, constant: 20).isActive = true
//            okayLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
//        }
//
//
////        dismissButton.addTarget(self, action: #selector(doneButton(_:)), for: .touchUpInside)
////        transitionButton.addTarget(self, action: #selector(transButton(_:)), for: .touchUpInside)
//    }
//
//    @objc func doneButton(_ sender: Any) {
//        print("done")
//        self.displayView.removeFromSuperview()
//    }
//
//    @objc func transButton(_ sender: Any) {
//
//    }
//
//    func userAllergic() -> [String]? {
//        if Double.random(in: 0...1) > 0.5{
//            return nil
//        } else {
//            return ["sadness", "unhappiness", "tears"]
//        }
//    }
//
//}
//
//func process(_ title: String) -> String {
//    //remove all UPC: stuff
//    let separated = title.split(separator: " ")
//    let filtered = separated.filter {arg in
//        return Int64(arg) == nil && arg != "UPC:"
//    }
//    return filtered.joined(separator: " ").replacingOccurrences(of: ",", with: "")
//}
//
