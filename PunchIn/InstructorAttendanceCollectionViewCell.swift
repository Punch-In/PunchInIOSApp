//
//  InstructorAttendanceCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class InstructorAttendanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var attendanceStudentsCount: UILabel!
    @IBOutlet weak var registeredStudentsCount: UILabel!
    
    @IBOutlet weak var attendanceTitleLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var registeredStudentsLabel: UILabel!
    
    func setAttendanceCollectionViewCell(){
        attendanceStudentsCount.textColor = ThemeManager.theme().primaryBlueColor()
        registeredStudentsCount.textColor = ThemeManager.theme().primaryBlueColor()
    
        /*Other Static Labels*/
        attendanceLabel.textColor  = ThemeManager.theme().primaryBlueColor()
//        attendanceLabel.font = ThemeManager.theme().primarySubTitleFont()
        
        attendanceTitleLabel.textColor = ThemeManager.theme().primaryBlueColor()
//        attendanceTitleLabel.font = ThemeManager.theme().primaryTitleFont()
        
        registeredStudentsLabel.textColor = ThemeManager.theme().primaryBlueColor()
//        registeredStudentsLabel.font = ThemeManager.theme().primarySubTitleFont()

    }
}
