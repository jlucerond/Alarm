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
    fileprivate let uniqueKey = "uniqueKey"
    
    var date: Date
    var title: String
    var isAlarmOn: Bool
    let uniqueID: UUID
    
    init(date: Date, title: String, isAlarmOn: Bool) {
        self.date = date
        self.title = title
        self.isAlarmOn = isAlarmOn
        self.uniqueID = UUID()
        super.init()
    }
    
    // MARK: - Saving & Loading Methods
    required init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: dateKey) as? Date,
            let title = aDecoder.decodeObject(forKey: titleKey) as? String,
            let uniqueID = aDecoder.decodeObject(forKey: uniqueKey) as? UUID else {
                return nil
        }
        
        self.date = date
        self.title = title
        self.isAlarmOn = aDecoder.decodeBool(forKey: isAlarmOnKey)
        self.uniqueID = uniqueID
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(isAlarmOn, forKey: isAlarmOnKey)
        aCoder.encode(date, forKey: dateKey)
        aCoder.encode(uniqueID, forKey: uniqueKey)
    }

}
