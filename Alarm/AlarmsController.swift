//
//  AlarmsController.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class AlarmsController {
    static var shared = AlarmsController()
    fileprivate var alarmsArray: [Alarm] = []
    var numberOfAlarms: Int {
        return alarmsArray.count
    }
    
    init() {
        createDummyData()
    }
}

extension AlarmsController {
    func createDummyData() {
        for x in 1...5 {
            let newAlarm = Alarm(date: Date(), title: "\(x)", isAlarmOn: (x % 2 == 0))
            alarmsArray.append(newAlarm)
        }
    }
}
