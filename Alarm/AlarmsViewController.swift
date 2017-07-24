//
//  AlarmsViewController.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AlarmsViewController: UITableViewController {
    
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
        cell?.delegate = self
        cell?.timeLabel.text = dueDateAsString(alarmDate: currentAlarm.date)
        // FIXME: - How to turn date into text?
        
        return cell ?? UITableViewCell()
    }
    
}

extension AlarmsViewController: AlarmTableViewCellDelegate {
    func switchIn(cell: UITableViewCell, wasToggledTo: Bool) {
        // find the item in the cell
        guard let indexPath = tableView.indexPath(for: cell),
            let alarm = AlarmsController.shared.alarmFor(row: indexPath.row) else {
            return
        }
        
        alarm.toggled()
    }
}

extension AlarmsViewController {
    func dueDateAsString(alarmDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: alarmDate)
    }
}
