//
//  DailyAttendanceCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class DailyAttendanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var className: UILabel!
    @IBOutlet private weak var classDate: UILabel!
    @IBOutlet private weak var classPresentOrAbsent: UILabel!
    
    weak var student: Student!
    var displayClass: Class! {
        didSet {
            className.text = displayClass.name
            classDate.text = displayClass.dateString
            classPresentOrAbsent.text = displayClass.didStudentAttend(student) ? "Present" : "Absent"
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        className.textColor = ThemeManager.theme().primaryBlueColor()
//        className.font = ThemeManager.theme().primaryTextFont()
        
        classDate.textColor = ThemeManager.theme().primaryBlueColor()
//        classDate.font = ThemeManager.theme().primaryTextFont()
        
        classPresentOrAbsent.textColor = ThemeManager.theme().primaryBlueColor()
//        classPresentOrAbsent.font = ThemeManager.theme().primaryTextFont()
    }
    

    
}
