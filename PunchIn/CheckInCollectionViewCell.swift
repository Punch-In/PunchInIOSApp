//
//  CheckInCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/31/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class CheckInCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var checkInStatusLabel: UILabel!
    @IBOutlet weak var MapViewButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var classCheckInWarning: UILabel!

    
    func setCheckInCollectionViewCell(){
        print("Set CheckIn Colleciton View Cell Called");
        checkInStatusLabel.text = "Check In to the class"
        classCheckInWarning.text = ""
    }

    
    
    

}
