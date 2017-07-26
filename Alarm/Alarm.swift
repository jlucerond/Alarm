//
//  Alarm.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class Alarm: NSObject, NSCoding {
    // MARK: - private keys
    fileprivate let dateKey = "dateKey"
    fileprivate let titleKey = "titleKey"
    fileprivate let isAlarmOnKey = "isAlarmOnKey"
    
    var date: Date
    let title: String
    var isAlarmOn: Bool
    
    init(date: Date, title: String, isAlarmOn: Bool) {
        self.date = date
        self.title = title
        self.isAlarmOn = isAlarmOn
        super.init()
    }
    
    // MARK: - Saving & Loading Methods
    required init?(coder aDecoder: NSCoder) {
        guard let dateAsString = aDecoder.decodeObject(forKey: dateKey) as? String,
            let title = aDecoder.decodeObject(forKey: titleKey) as? String else {
                return nil
        }
        
        self.date = Date.distantFuture
        self.title = title
        self.isAlarmOn = aDecoder.decodeBool(forKey: isAlarmOnKey)
        super.init()
        
        self.date = turnStringIntoDate(string: dateAsString)

    }
    
    func encode(with aCoder: NSCoder) {
        let dateAsString = turnDateIntoString(date: date)
        
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(isAlarmOn, forKey: isAlarmOnKey)
        aCoder.encode(dateAsString, forKey: dateKey)
    }
    
    // MARK: - Instance Methods
    func toggled() {
        isAlarmOn = !isAlarmOn
    }
}

extension Alarm {
    func turnDateIntoString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let myString = dateFormatter.string(from: date)
        
        return myString
    }
    
    func turnStringIntoDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let myDate = dateFormatter.date(from: string)!
        
        return myDate
    }
}

