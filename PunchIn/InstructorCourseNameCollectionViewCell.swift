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
    @IBOutlet weak var classDateLabel: UILabel!
    
    weak var displayClass: Class! {
        didSet {
            className.text = displayClass.name
            classDescription.text = displayClass.classDescription
            classDateLabel.text = displayClass.dateString
        }
    }

    
    func setupUI(){
        //Class Names
        className.textColor = ThemeManager.theme().primaryDarkBlueColor()
        //Class Description
        classDescription.textColor = ThemeManager.theme().primaryBlueColor()
        // class date
        classDateLabel.textColor = ThemeManager.theme().primaryGreyColor()
    }
    
}
