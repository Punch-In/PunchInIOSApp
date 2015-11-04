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
    @IBOutlet private weak var attendanceStatusImageView: UIImageView!
    @IBOutlet private weak var attendanceStatusWrapperView: UIView!
    
    weak var student: Student!
    var displayClass: Class! {
        didSet {
            className.text = displayClass.name
            classDate.text = displayClass.dateString
            if displayClass.isFinished {
                attendanceStatusImageView.hidden = false
                if displayClass.didStudentAttend(student) {
                    attendanceStatusImageView.image = UIImage(named: "selected_checkin")
                }else{
                    attendanceStatusImageView.image = UIImage(named: "redmark")
                }
            } else if displayClass.isStarted {
                attendanceStatusImageView.hidden = false
                if displayClass.didStudentAttend(student) {
                    attendanceStatusImageView.image = UIImage(named: "selected_checkin")
                }else{
                    attendanceStatusImageView.image = UIImage(named: "unsurequestionmark")
                }
                
            }else{
                // hide the attendance view because the class hasn't started yet
                attendanceStatusImageView.hidden = true
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupUI() {
        className.textColor = ThemeManager.theme().primaryBlueColor()
        classDate.textColor = ThemeManager.theme().primaryBlueColor()

        attendanceStatusImageView.layer.cornerRadius = 6.0
        attendanceStatusImageView.clipsToBounds = true
        attendanceStatusWrapperView.layer.cornerRadius = 6.0
        attendanceStatusWrapperView.clipsToBounds = true

    }
    

    
}
