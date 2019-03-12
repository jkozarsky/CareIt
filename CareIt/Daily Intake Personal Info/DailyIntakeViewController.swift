//
//  DailyIntakeViewController.swift
//  CareIt
//
//  Created by Katherine Wang (student LM) on 2/25/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class DailyIntakeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var Calendar: UICollectionView!
    
    @IBOutlet weak var Month: UILabel!
    
    @IBOutlet weak var recomCalories: UILabel!
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfMonth = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int() //num of empty boxes at the start of the current month
    var nextNumberOfEmptyBox = Int() //same but for next month
    var previousNumberOfEmptyBox = 0 //same but for last month
    var direction = 0 //0 if current month, 1 if future, -1 if past
    var positionIndex = 0 //store the above vars of the empty boxes
    var leapYearCounter = 1 //next leap year is next year
    
    //for getting stuff from firebase
    var userInfo: [String: Any]? = [:]
    
    func getFirstWeekDay() -> Int {
        //        let day = ("\(year)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentMonth = Months[month]
        Month.text = "\(currentMonth) \(year)"
        
        //        firstWeekDayOfMonth=getFirstWeekDay()
        //
        //        //for leap years, make february month of 29 days
        //        if currentMonthIndex == 2 && currentYear % 4 == 0 {
        //            numOfDaysInMonth[currentMonthIndex-1] = 29
        //        }
        
        super.viewDidLoad()
        
        //FIND USERINFO
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("users\(uid)")
        
        databaseRef.observeSingleEvent(of: .value, with: {snapshot in
            self.userInfo = snapshot.value as? [String: Any] ?? [:]
        })
        
        print(month)
        print(day)
        print(year)
        print(DaysOfMonth[weekday])
        
        //To do: ask jason about getting calories
        
        //        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        //        let age = ageComponents.year!
        //
        //        if (sex=="Female") {
        //            recomCalories = 10*(weight/2.20462) + 6.25*(height/0.393701) - 5*age - 161
        //        }
        //        else {
        //            recomCalories = 10*(weight/2.20462) + 6.25*(height/0.393701) - 5*age + 5
        //        }
        //
        //        if (activity == "Low") {
        //            recomCalories *= 1.2
        //        }
        //        else if (activity == "Medium") {
        //            recomCalories *= 1.3
        //        }
        //        else {
        //            recomCalories *= 1.4
        //        }
    }
    
    
    
    @IBAction func next(_ sender: UIButton) {
        
        direction = 1
        switch currentMonth{
        case "December":
            month = 0
            year += 1
            
        default:
            month += 1
        }
        
        currentMonth = Months[month]
        
        Month.text = "\(currentMonth) \(year)"
        
        
        
        
        
        getStartDateDayPosition()
        Calendar.reloadData()
    }
    
    @IBAction func back(_ sender: UIButton) {
        
        direction = -1
        switch currentMonth{
        case "January":
            month = 11
            year -= 1
            
        default:
            month -= 1
        }
        
        currentMonth = Months[month]
        Month.text = "\(currentMonth) \(year)"
        
        getStartDateDayPosition()
        Calendar.reloadData()
    }
    
    
    
    func getStartDateDayPosition(){
        switch direction{
        case 0:
            switch day{
            case 1...7:
                numberOfEmptyBox = weekday - day
            case 8...14:
                numberOfEmptyBox = weekday - day - 7
            case 15...21:
                numberOfEmptyBox = weekday - day - 14
            case 22...28:
                numberOfEmptyBox = weekday - day - 21
            case 29...31:
                numberOfEmptyBox = weekday - day - 28
            default:
                break
            }
            positionIndex = numberOfEmptyBox
            
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + DaysInMonths[month]) % 7
            positionIndex = nextNumberOfEmptyBox
        case -1:
            previousNumberOfEmptyBox = (7-(DaysInMonths[month]-positionIndex)%7)
            if previousNumberOfEmptyBox==7{
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
            
        default:
            fatalError()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //returns the number of days in the month + the number of "empty boxes" based on the direction we're going
        switch direction{
        case 0:
            return DaysInMonths[month] + numberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
        //
        //        return DaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.DateLabel.textColor = UIColor.black
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        switch direction{
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1...:
            cell.DateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        //hides every cell smaller than one
        if Int(cell.DateLabel.text!)! < 1{
            cell.isHidden = true
        }
        
        //show weekdays in different color
        switch indexPath.row{
        case 5, 6, 12, 13, 19, 20, 26, 27, 33, 34:
            if Int(cell.DateLabel.text!)! > 0 {
                cell.DateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        //current date marked in red
        if currentMonth == Months[calendar.component(.month, from: date)-1] && year == calendar.component(.year, from: date) && indexPath.row + 1 + numberOfEmptyBox == day{
            cell.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    
    
    //did select cell: change cell background to red
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.red
        //        let lbl = cell?.subviews[1] as! UILabel
        //        lbl.textColor=UIColor.white
        
        
        //do display nutrient info stuff here
//        recomCalories.text = userInfo[""]
        
        
    }
    
    //did deselect cell: change to clear
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        //        let lbl = cell?.subviews[1] as! UILabel
        //        lbl.textColor = Style.activeCellLblColor
    }


}
