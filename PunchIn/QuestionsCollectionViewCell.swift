//
//  QuestionsCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/31/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class QuestionsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet private weak var questionsCount: UILabel!
    
    var numQuestions:Int! {
        didSet{
            questionsCount.text = "\(numQuestions)"
            questionsCount.hidden = false
        }
    }
    
    func setupUI() {
        questionsCount.hidden = true
    }
    
}
