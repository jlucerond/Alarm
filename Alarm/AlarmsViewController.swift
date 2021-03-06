//
//  AlarmsViewController.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AlarmsViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension AlarmsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmsController.shared.numberOfAlarms
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let  currentAlarm = AlarmsController.shared.alarmFor(row: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmTableViewCell
        cell?.titleLabel.text = currentAlarm.title
        cell?.timeLabel.text = dueDateAsString(alarmDate: currentAlarm.date)
        cell?.switchControl.isOn = currentAlarm.isAlarmOn
        cell?.delegate = self
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let alarm = AlarmsController.shared.alarmFor(row: indexPath.row) {
                tableView.beginUpdates()
                AlarmsController.shared.remove(existingAlarm: alarm)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}

// MARK: - Alarm Table View Cell Delegate & Saving/Canceling Notification
extension AlarmsViewController: AlarmTableViewCellDelegate, AlarmScheduler {
    func switchIn(cell: UITableViewCell, wasToggledTo: Bool) {
        // find the item in the cell
        guard let indexPath = tableView.indexPath(for: cell),
            let alarm = AlarmsController.shared.alarmFor(row: indexPath.row) else {
            return
        }
        
        AlarmsController.shared.alarmWasToggled(alarm: alarm)
        if alarm.isAlarmOn {
            cancelUserNotifications(for: alarm)
            scheduleUserNotification(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        
    }
}

// MARK: - Navigation
extension AlarmsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewAlarm" {
            guard let nextViewController = segue.destination as? AlarmDetailViewController else {
                return
            }
            nextViewController.title = "Add Alarm"
            
        } else if segue.identifier == "editAlarm" {
            guard let nextViewController = segue.destination as? AlarmDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let selectedAlarm = AlarmsController.shared.alarmFor(row: indexPath.row) else {
                return
            }
            
            nextViewController.alarm = selectedAlarm

        }
    }
}

// MARK: - Helper Methods
extension AlarmsViewController {
    func dueDateAsString(alarmDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: alarmDate)
    }
}
