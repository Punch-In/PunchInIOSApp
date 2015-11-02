//
//  DailyAttendanceCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class DailyAttendanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classDate: UILabel!
    @IBOutlet weak var classPresentOrAbsent: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        className.textColor = ThemeManager.theme().primaryBlueColor()
        className.font = ThemeManager.theme().primaryTextFont()
        
        classDate.textColor = ThemeManager.theme().primaryBlueColor()
        classDate.font = ThemeManager.theme().primaryTextFont()
        
        classPresentOrAbsent.textColor = ThemeManager.theme().primaryBlueColor()
        classPresentOrAbsent.font = ThemeManager.theme().primaryTextFont()
    }
    

    
}
