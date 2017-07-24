//
//  Alarm.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class Alarm {
    let date: Date
    let title: String
    var isAlarmOn: Bool
    
    init(date: Date, title: String, isAlarmOn: Bool) {
        self.date = date
        self.title = title
        self.isAlarmOn = isAlarmOn
    }
    
    func toggled() {
        isAlarmOn = !isAlarmOn
    }
}
