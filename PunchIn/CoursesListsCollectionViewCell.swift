//
//  CoursesListsCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

protocol CourseListsGoToAttendanceViewDelegate: class {
    func goToAttendanceDetails(course:Course)
}

class CoursesListsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var courseNameLabel:UILabel!
    @IBOutlet private weak var courseImageView: UIImageView!
    @IBOutlet private weak var goToAttendanceLabel: UILabel!
    
    weak var goToAttendanceDelegate: CourseListsGoToAttendanceViewDelegate?
    
    weak var displayCourse: Course! {
        didSet {
            courseNameLabel.text = displayCourse.courseName as String!
            displayCourse.getImage { (image, error) -> Void in
                if error == nil {
                    self.courseImageView.alpha = 0.0
                    self.courseImageView.image = image
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.courseImageView.alpha = 1.0
                    })
                }
            }
        }
    }
    
    func setupUI(){
        courseNameLabel?.textColor = UIColor.whiteColor()
        
        // add gesture recognizer to attendance label (if visible)
        if ParseDB.isStudent {
            goToAttendanceLabel.hidden = false
            let gesture = UITapGestureRecognizer(target: self, action: "didTapGoToAttendance")
            goToAttendanceLabel.addGestureRecognizer(gesture)
            goToAttendanceLabel.text = "my attendance"
        }else{
            goToAttendanceLabel.hidden = true
        }
    }
    
    func didTapGoToAttendance() {
        if let delegate = goToAttendanceDelegate {
            delegate.goToAttendanceDetails(displayCourse)
        }
    }
    
}
