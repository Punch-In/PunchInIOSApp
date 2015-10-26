//
//  CoursesListsCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class CoursesListsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var courseNameLabel:UILabel?

    func setCoursesListCollectionViewCell(course:Course){
        courseNameLabel?.text = course.courseName as String!;
    }
    
    
    
}
