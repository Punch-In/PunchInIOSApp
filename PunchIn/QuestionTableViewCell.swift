//
//  QuestionTableViewCell.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/25/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    var question:Question! {
        didSet {
            personNameField.text = question.askedBy
            questionTextView.text = question.questionText
            
            questionDateField.text = question.absoluteDateString
            if let forClass = question.forClass {
                if !forClass.isFinished {
                    // if class isn't finished, instaed show time since question
                    questionDateField.text = question.sinceDateString + " ago"
                }
            }
//            questionAnsweredControl.selectedSegmentIndex = question.isAnswered ? 1 : 0
        }
    }
    
    
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet private weak var personNameField: UILabel!
    @IBOutlet private weak var questionDateField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        // Initialization code
    }
    
    private func setupUI() {
        // configure font colors
        personNameField.textColor = ThemeManager.theme().primaryGreyColor()
        questionTextView.textColor = ThemeManager.theme().primaryBlueColor()
        questionTextView.backgroundColor = UIColor.redColor()
        questionDateField.textColor = ThemeManager.theme().primaryBlueColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
