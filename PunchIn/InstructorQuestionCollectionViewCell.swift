//
//  InstructorQuestionCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class InstructorQuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var unansweredCount: UILabel!
    @IBOutlet private weak var questionsCount: UILabel!
    @IBOutlet private weak var unsweredSubtitleLabels: UILabel!
    @IBOutlet private weak var questionsSubTitleLabel: UILabel!
    
    var displayClass: Class! {
        didSet {
            questionsCount.text = "\(displayClass.questions!.count)"
            displayClass.refreshQuestions { (questions, error) -> Void in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()){
                        self.unansweredCount.text = "\(questions!.filter({!$0.isAnswered}).count)"
                    }
                }else{
                    print("error getting questions???")
                }
            }
        }
    }
    
    func questionsCollectionViewCell(){
        unansweredCount.textColor = ThemeManager.theme().primaryBlueColor()
        questionsCount.textColor = ThemeManager.theme().primaryBlueColor()
        
        /*Static Labels*/
        unsweredSubtitleLabels.textColor = ThemeManager.theme().primaryBlueColor()
        unsweredSubtitleLabels.alpha = 0.75
        
        questionsSubTitleLabel.textColor = ThemeManager.theme().primaryBlueColor()
        questionsSubTitleLabel.alpha = 0.75
    }    
}
