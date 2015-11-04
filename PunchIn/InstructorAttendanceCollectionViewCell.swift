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
    
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var registeredStudentsLabel: UILabel!
    
    var displayClass:Class!{
        didSet {
            attendanceStudentsCount.text = "\(displayClass.attendance!.count)"
            registeredStudentsCount.text = "\(displayClass.parentCourse.registeredStudents!.count)"
        }
    }
    
    func setupUI(){
        attendanceStudentsCount.textColor = ThemeManager.theme().primaryDarkBlueColor()
        registeredStudentsCount.textColor = ThemeManager.theme().primaryDarkBlueColor()
    
        /*Other Static Labels*/
        attendanceLabel.textColor  = ThemeManager.theme().primaryBlueColor()
        attendanceLabel.alpha = 0.75
        
        registeredStudentsLabel.textColor = ThemeManager.theme().primaryBlueColor()
        registeredStudentsLabel.alpha = 0.75
    }
}
