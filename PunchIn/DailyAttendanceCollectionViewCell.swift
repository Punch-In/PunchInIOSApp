//
//  DailyAttendanceCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class DailyAttendanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classDate: UILabel!
    @IBOutlet weak var classPresentOrAbsent: UILabel!
    
    func setAttendance(attendance:Attendance){
        className.text = attendance.className
        classDate.text = attendance.classDate
        classPresentOrAbsent.text = attendance.classPresentOrAbsent
    }
    
    
}
