//
//  CoursesListsCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class CoursesListsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var courseNameLabel:UILabel!
    @IBOutlet weak var courseImageView: UIImageView!
    
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
        //courseNameLabel?.font = ThemeManager.theme().primaryTitleFont()
    }
    
    
    
}
