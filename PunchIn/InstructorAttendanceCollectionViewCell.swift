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
    
    func setAttendanceCollectionViewCell(){
        attendanceStudentsCount.textColor = ThemeManager.theme().primaryBlueColor()
        
        registeredStudentsCount.textColor =
            ThemeManager.theme().primaryBlueColor()
    }
}
