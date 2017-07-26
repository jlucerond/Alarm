//
//  AlarmsController.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmsController {
    static var shared = AlarmsController()
    fileprivate var alarmsArray: [Alarm] = []
    var numberOfAlarms: Int {
        return alarmsArray.count
    }
    
    init() {
        loadFromPersistentData()
    }
}

// MARK: - CRUD Functions
extension AlarmsController {
    func alarmFor(row: Int) -> Alarm? {
        return alarmsArray[row]
    }
    
    func addNewAlarmWith(title: String, date: Date, shouldAlert: Bool) -> Alarm {
        let newAlarm = Alarm(date: date, title: title, isAlarmOn: shouldAlert)
        alarmsArray.append(newAlarm)
        saveToPersistentData()
        return newAlarm
    }
    
    func edit(existingAlarm: Alarm, newTitle: String, newDate: Date, shouldAlert: Bool) {
        guard let index = alarmsArray.index(of: existingAlarm),
            index < numberOfAlarms else {
                return
        }
        
        let newAlarm = existingAlarm
        newAlarm.title = newTitle
        newAlarm.date = newDate
        newAlarm.isAlarmOn = shouldAlert
        
        alarmsArray[index] = newAlarm
        saveToPersistentData()
    }
    
    func alarmWasToggled(alarm: Alarm) {
        // FIXME: - Best practice here for saving data?
        alarm.isAlarmOn = !alarm.isAlarmOn
        saveToPersistentData()
    }
    
    func remove(existingAlarm: Alarm) {
        guard let index = alarmsArray.index(of: existingAlarm) else {
            return
        }
        alarmsArray.remove(at: index)
        saveToPersistentData()
    }
    
}

// MARK: - Persistent Functions
fileprivate extension AlarmsController {
    
    func documentURLAsString() -> String? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = urls.first?.appendingPathComponent("Alarms.plist") else {
            return nil
        }
        
        return documentURL.relativePath
    }
    
    func saveToPersistentData() {
        guard let urlSaveString = documentURLAsString() else { return }
        
        let didSave = NSKeyedArchiver.archiveRootObject(alarmsArray, toFile: urlSaveString)
        
        print("Did successfully save: \(didSave)")
    }
    
    func loadFromPersistentData() {
        guard let saveString = documentURLAsString(),
            let savedAlarms = NSKeyedUnarchiver.unarchiveObject(withFile: saveString) as? [Alarm] else {
                print("Do not have a save alarms object")
                return
        }
        print("Did successfully load alarms")
        alarmsArray = savedAlarms
    }
    
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
}

// MARK: - AlarmScheduler Protocol Methods
protocol AlarmScheduler { }

extension AlarmScheduler {
    func scheduleUserNotification(for alarm: Alarm) {
        if alarm.isAlarmOn {
            let content = UNMutableNotificationContent()
            content.title = alarm.title
            content.body = alarm.date.description
            content.badge = 1
            content.sound = UNNotificationSound.default()
            
            let dateComponents = Calendar.current.dateComponents([.hour, .minute],
                                                                 from: alarm.date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: true)
            
            let request = UNNotificationRequest(identifier: alarm.uniqueID.uuidString,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: nil)
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uniqueID.uuidString])
    }
}
