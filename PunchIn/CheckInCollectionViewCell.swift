
//
//  CheckInCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/31/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit




class CheckInCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkIntoClassLabel: UILabel!
    @IBOutlet weak var checkinWarningLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var checkInButtonClicked: UIButton!
    
    private var aAllowedToCheckIn:Bool!
    private var aMessage:String!
    private var aCurrentClass:Class!
    
    weak var currentClass:Class!
    
    
    func setUpUI(){
        
        checkinWarningLabel.text = ""
        checkinWarningLabel.textColor = UIColor.greenColor()
        
        checkIntoClassLabel.text = "Check in to the class"
        checkIntoClassLabel.textColor = UIColor.whiteColor()
        //checkIntoClassLabel.font = ThemeManager.theme().primaryTitleFont()
        
        
        
        
        self.backgroundColor = ThemeManager.theme().primaryYellowColor()
        checkInButton.setImage(UIImage.init(named: "unselected_checkin"), forState: .Normal)
        checkInButton.setImage(UIImage.init(named: "selected_checkin"), forState: .Selected)
    }
    
    func setUpValuesForCheckIn(currentClass : Class, allowedToCheckIn : Bool,message:String){
        aAllowedToCheckIn = allowedToCheckIn
        aMessage = message
        aCurrentClass = currentClass
    }
    
    @IBAction func checkInButtonActionClicked(sender: AnyObject) {
        print("Sender State \(checkInButton.state)")
        if !self.aAllowedToCheckIn {
            //Not allowed to check in.
            checkinWarningLabel.text = aMessage
            checkinWarningLabel.textColor = UIColor.whiteColor()
            checkInButton.backgroundColor = UIColor.whiteColor()
        }else{
            //Allowed to check in.
            checkInButton.selected = !checkInButton.selected;
            checkinWarningLabel.text = " "
        }
    }
}



