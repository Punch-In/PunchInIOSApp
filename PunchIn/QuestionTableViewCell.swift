//
//  QuestionTableViewCell.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/25/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    private static var questionDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ssa MMM dd y"
        return formatter
    }()
    
    var question:Question! {
        didSet {
            studentNameField.text = question.askedBy
            questionTextField.text = question.questionText
            questionDateField.text = QuestionTableViewCell.questionDateFormatter.stringFromDate(question.date)
        }
    }
    
    @IBOutlet private weak var studentNameField: UILabel!
    @IBOutlet private weak var questionTextField: UILabel!
    @IBOutlet private weak var questionDateField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
