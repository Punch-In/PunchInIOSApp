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
            studentNameField.text = question.askedBy
            questionTextField.text = question.questionText
            
            questionDateField.text = question.absoluteDateString
            if let forClass = question.forClass {
                if !forClass.isFinished {
                    questionDateField.text = question.sinceDateString + " ago"
                }
            }
            questionAnsweredControl.selectedSegmentIndex = question.isAnswered ? 1 : 0
        }
    }
    
    @IBOutlet private weak var questionTextField: UITextField!
    @IBOutlet private weak var studentNameField: UILabel!
    @IBOutlet private weak var questionDateField: UILabel!
    @IBOutlet private weak var questionAnsweredControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        // Initialization code
    }
    
    private func setupUI() {
        // configure font colors
        studentNameField.textColor = ThemeManager.theme().primaryGreyColor()
        questionTextField.textColor = ThemeManager.theme().primaryBlueColor()
        questionDateField.textColor = ThemeManager.theme().primaryBlueColor()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
