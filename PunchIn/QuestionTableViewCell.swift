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
            
//            if question.isAnswered {
//                questionAnsweredImage.hidden = false
//            }else{
//                questionAnsweredImage.hidden = true
//            }
        }
    }
    
    
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet private weak var personNameField: UILabel!
    @IBOutlet private weak var questionDateField: UILabel!
    @IBOutlet weak var questionAnsweredImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        // Initialization code
    }
    
    private func setupUI() {
        // configure font colors
        personNameField.textColor = ThemeManager.theme().primaryGreyColor()
        questionTextView.textColor = ThemeManager.theme().primaryBlueColor()
        questionDateField.textColor = ThemeManager.theme().primaryBlueColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
