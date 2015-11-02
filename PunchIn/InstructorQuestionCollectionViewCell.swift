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
    @IBOutlet weak var questionsTitleLabel: UILabel!
    @IBOutlet weak var unsweredSubtitleLabels: UILabel!
    @IBOutlet weak var questionsSubTitleLabel: UILabel!
    
    func questionsCollectionViewCell(){
        unansweredCount.textColor = ThemeManager.theme().primaryBlueColor()
        questionsCount.textColor = ThemeManager.theme().primaryBlueColor()
        
        /*Static Labels*/
        questionsTitleLabel.textColor = ThemeManager.theme().primaryBlueColor()
        questionsTitleLabel.font = ThemeManager.theme().primaryTitleFont()
        
        unsweredSubtitleLabels.textColor = ThemeManager.theme().primaryBlueColor()
        unsweredSubtitleLabels.font = ThemeManager.theme().primarySubTitleFont()
        
        questionsSubTitleLabel.textColor = ThemeManager.theme().primaryBlueColor()
        questionsSubTitleLabel.font = ThemeManager.theme().primarySubTitleFont()
        
        
    }
}
