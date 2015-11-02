//
//  ClassNameCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/31/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class ClassNameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classDescription: UILabel!
    @IBOutlet weak var classDate: UILabel!
    
    weak var displayClass: Class! {
        didSet {
            className.text = displayClass.name
            classDescription.text = displayClass.classDescription
            classDate.text = displayClass.dateString
        }
    }
    
    func setUpclassCell(){
    
        className.textColor = ThemeManager.theme().primaryDarkBlueColor()
        //className.font = ThemeManager.theme().primaryTitleFont()
        
        classDescription.textColor = ThemeManager.theme().primaryBlueColor()
        //classDescription.font = ThemeManager.theme().primarySubTitleFont()
        
        classDate.textColor = ThemeManager.theme().primaryGreyColor()
        //classDescription.font = ThemeManager.theme().primarySubTitleFont()
    
    }
}
