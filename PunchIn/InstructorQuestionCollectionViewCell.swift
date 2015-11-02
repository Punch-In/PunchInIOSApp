//
//  InstructorQuestionCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class InstructorQuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var unansweredCount: UILabel!
    @IBOutlet weak var questionsCount: UILabel!
    
    func questionsCollectionViewCell(){
        unansweredCount.textColor = ThemeManager.theme().primaryBlueColor()
        questionsCount.textColor = ThemeManager.theme().primaryBlueColor()
    }
}
