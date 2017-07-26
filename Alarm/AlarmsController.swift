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
        loadFromPersistentData()
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
        saveToPersistentData()
    }
    
    func edit(existingAlarm: Alarm, newTitle: String, newDate: Date, shouldAlert: Bool) {
        guard let index = alarmsArray.index(of: existingAlarm),
        index < numberOfAlarms else {
            return
        }
        
        let newAlarm = Alarm(date: newDate, title: newTitle, isAlarmOn: shouldAlert)
        alarmsArray[index] = newAlarm
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
        print(saveString)
        print("Did successfully load alarms")
        alarmsArray = savedAlarms
    }
    
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
}

// MARK: - Create Dummy Data
fileprivate extension AlarmsController {
    func createDummyData() {
        for x in 1...5 {
            let newAlarm = Alarm(date: Date(), title: "Alarm #\(x)", isAlarmOn: (x % 2 == 0))
            alarmsArray.append(newAlarm)
        }
    }
}
