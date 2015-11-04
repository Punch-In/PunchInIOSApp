
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
    
    weak var displayClass:Class! {
        didSet {
            if displayClass.isFinished {
                classIsFinished()
            }else if displayClass.isStarted {
                classIsStarted()
            }else {
                classNotStarted()
            }
        }
    }
    
    weak var student:Student!
    
    func setUpUI(){
        
        checkinWarningLabel.text = ""
        checkinWarningLabel.textColor = UIColor.greenColor()
        
        checkIntoClassLabel.text = ""
        checkIntoClassLabel.textColor = UIColor.whiteColor()
        
        self.backgroundColor = ThemeManager.theme().primaryYellowColor()
        checkInButton.setBackgroundImage(UIImage(named: "whiteicon"), forState: .Normal)
        checkInButton.setBackgroundImage(UIImage(named: "whiteicon"), forState: .Selected)
        checkInButton.setImage(nil, forState: .Normal)
        checkInButton.setImage(nil, forState: .Selected)
//        checkInButton.setBackgroundImage(UIImage.init(named: "unselected_checkin"), forState: .Normal)
//        checkInButton.setBackgroundImage(UIImage.init(named: "selected_checkin"), forState: .Selected)
    }

    private func classIsFinished() {
        print("class \(displayClass.name) is finished")
        checkIntoClassLabel.text = Class.textForClassFinished
        checkinWarningLabel.hidden = true
        checkInButton.hidden = false
        checkInButton.selected = true
        checkInButton.userInteractionEnabled = false
        if displayClass.didStudentAttend(student) {
            checkInButton.setImage(UIImage(named: "checkmark"), forState: .Selected)
//            checkInButton.setBackgroundImage(UIImage.init(named: "selected_checkin"), forState: .Selected)
        }else{
            checkInButton.setImage(UIImage(named: "redmark"), forState: .Selected)
//            checkInButton.setBackgroundImage(UIImage.init(named: "redmark"), forState: .Selected)
        }
    }
    
    private func classNotStarted() {
        print("class \(displayClass.name) is not started")
        checkIntoClassLabel.text = Class.textForStudentClassNotStarted
        checkInButton.hidden = true
        checkInButton.userInteractionEnabled = false
        checkinWarningLabel.hidden = true
    }
    
    private func classIsStarted() {
        checkInButton.hidden = false
        checkinWarningLabel.hidden = true
        if displayClass.didStudentAttend(student) {
            print("class \(displayClass.name) is started and student attended")
            checkIntoClassLabel.text = Class.textForStudentClassCheckedIn
            checkInButton.selected = true
            checkInButton.userInteractionEnabled = false
        }else{
            print("class \(displayClass.name) is started and student has not attended")
            if displayClass.isWaitingToAttend {
                // show question mark as status is unknown
                checkInButton.setImage(UIImage(named: "unsurequestionmark"), forState: .Normal)
            }
            checkIntoClassLabel.text = Class.textForStudentClassStarted
            checkInButton.selected = false
            checkInButton.userInteractionEnabled = true
        }
    }
    
    func showWarning() {
        checkinWarningLabel.hidden = false
        checkinWarningLabel.text = Class.textForStudentOutsideGeofence
//        checkInButton.setImage(UIImage(named: "unsurequestionmark"), forState: .Selected)
        checkInButton.setImage(UIImage(named: "unsurequestionmark"), forState: .Normal)
    }
    
    @IBAction func checkInButtonActionClicked(sender: AnyObject) {
        print("Sender State \(checkInButton.state)")
        
        // need to remember whether student has tried to check in for class already
    }
}



