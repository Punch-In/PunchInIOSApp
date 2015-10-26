//
//  AttendanceCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class AttendanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var totalAttendance: UILabel!

    func setAttendanceOfStudent(student:Student){
        studentName.text = student.studentName
        studentImage.image = student.studentImage
        totalAttendance.text = student.attendanceOfStudent
    }
    
    
    
}
