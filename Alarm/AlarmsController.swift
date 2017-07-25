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

// MARK: - CRUD Functions
extension AlarmsController {
    func alarmFor(row: Int) -> Alarm? {
        return alarmsArray[row]
    }
    
    func addNewAlarmWith(title: String, date: Date, shouldAlert: Bool) {
        let newAlarm = Alarm(date: date, title: title, isAlarmOn: shouldAlert)
        alarmsArray.append(newAlarm)
    }
    
    func edit(existingAlarm: Alarm, newTitle: String, newDate: Date, shouldAlert: Bool) {
        guard let index = alarmsArray.index(of: existingAlarm),
        index < numberOfAlarms else {
            return
        }
        
        let newAlarm = Alarm(date: newDate, title: newTitle, isAlarmOn: shouldAlert)
        alarmsArray[index] = newAlarm
    }
}

extension AlarmsController {
    func createDummyData() {
        for x in 1...5 {
            let newAlarm = Alarm(date: Date(), title: "Alarm #\(x)", isAlarmOn: (x % 2 == 0))
            alarmsArray.append(newAlarm)
        }
    }
}
