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
    
    func setUpclassCell(){
    
        className.textColor = ThemeManager.theme().primaryBlueColor()
        className.font = ThemeManager.theme().primaryTitleFont()
        
        classDescription.textColor = ThemeManager.theme().primaryBlueColor()
        classDescription.font = ThemeManager.theme().primarySubTitleFont()
    
    }
}
