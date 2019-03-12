//
//  CalendarVars.swift
//  CareIt
//
//  Created by Katherine Wang (student LM) on 3/11/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
