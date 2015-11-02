//
//  InstructorCourseNameCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class InstructorCourseNameCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classDescription: UILabel!
    
    func setUpCourseName(){
        className.textColor = ThemeManager.theme().primaryBlueColor()
        classDescription.textColor = ThemeManager.theme().primaryBlueColor()
    }
}
