//
//  AlarmDetailViewController.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AlarmDetailViewController: UITableViewController, AlarmScheduler {
    // IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var alarmEnabledButton: UIButton!
    
    // Variables
    var alarm: Alarm?
    var alarmIsOn: Bool = true
    
    // IBActions
    @IBAction func alarmEnabledPushed() {
        alarmIsOn = !alarmIsOn
        updateViews()
    }
    
    @IBAction func saveButtonPushed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else {
            return
        }
                
        let date = datePicker.date

        if let alarm = alarm {
            // edit alarm
            cancelUserNotifications(for: alarm)
            AlarmsController.shared.edit(existingAlarm: alarm, newTitle: title, newDate: date, shouldAlert: alarmIsOn)
            if alarm.isAlarmOn { scheduleUserNotification(for: alarm) }
            navigationController?.popViewController(animated: true)
        } else {
            // create new alarm
            let newAlarm = AlarmsController.shared.addNewAlarmWith(title: title, date: date, shouldAlert: alarmIsOn)
            scheduleUserNotification(for: newAlarm)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    // Life Cycle Methods
    override func viewDidLoad() {
        if let alarm = alarm {
            titleTextField.text = alarm.title
            datePicker.date = alarm.date as Date
            alarmIsOn = alarm.isAlarmOn
            title = alarm.title
        }
        updateViews()
    }
}

// MARK: - Helper Methods
extension AlarmDetailViewController {
    func updateViews() {
        if alarmIsOn {
            alarmEnabledButton.setTitle("Alarm is On", for: .normal)
            alarmEnabledButton.backgroundColor = UIColor.red
        } else {
            alarmEnabledButton.setTitle("Off", for: .normal)
            alarmEnabledButton.backgroundColor = UIColor.lightGray
        }
        
        guard let text = titleTextField.text else {
            saveButton.isEnabled = false
            return
        }
        
        saveButton.isEnabled = !text.isEmpty
    }
}

extension AlarmDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return true
        }
        let newText = text.replacingCharacters(in: range, with: string)
        
        saveButton.isEnabled = !newText.isEmpty
        return true
    }
}
