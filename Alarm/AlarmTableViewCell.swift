//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by Joe Lucero on 7/24/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

protocol AlarmTableViewCellDelegate: class {
    func switchIn(cell: UITableViewCell, wasToggledTo: Bool)
}

class AlarmTableViewCell: UITableViewCell {
    // IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    // Variables
    weak var delegate: AlarmTableViewCellDelegate?
    
    // IBActions
    @IBAction func switchToggled() {
        delegate?.switchIn(cell: self, wasToggledTo: switchControl.isOn)
    }

}
