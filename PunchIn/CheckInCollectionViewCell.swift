
//
//  CheckInCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/31/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit




class CheckInCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var checkIntoClassLabel: UILabel!
    @IBOutlet private weak var checkinWarningLabel: UILabel!
    @IBOutlet private weak var checkInButton: UIButton!
    @IBOutlet private weak var mapButton: UIButton!
    @IBOutlet private weak var checkInButtonClicked: UIButton!
    @IBOutlet private weak var checkInButtonWrapperView: UIView!
    
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
        checkinWarningLabel.textColor = UIColor.redColor()
        
        checkIntoClassLabel.text = ""
        checkIntoClassLabel.textColor = UIColor.whiteColor()
        
        self.backgroundColor = ThemeManager.theme().primaryYellowColor()
        
        // configure check in button
        checkInButton.hidden = true
        checkInButton.layer.cornerRadius = 6.0
        checkInButton.clipsToBounds = true
        checkInButtonWrapperView.hidden = true
        checkInButtonWrapperView.layer.cornerRadius = 6.0
        checkInButtonWrapperView.clipsToBounds = true
    }

    private func classIsFinished() {
        print("class \(displayClass.name) is finished")
        checkIntoClassLabel.text = Class.textForClassFinished
        checkinWarningLabel.hidden = true
        checkInButton.hidden = false
        checkInButtonWrapperView.hidden = false
        checkInButton.selected = true
        checkInButton.userInteractionEnabled = false
        if displayClass.didStudentAttend(student) {
			checkInButton.setBackgroundImage(UIImage(named: "selected_checkin"), forState: .Selected)     
        }else{
            checkInButton.setBackgroundImage(UIImage(named: "redmark"), forState: .Selected)
        }
    }
    
    private func classNotStarted() {
        print("class \(displayClass.name) is not started")
        checkIntoClassLabel.text = Class.textForStudentClassNotStarted
        checkInButton.hidden = true
        checkInButton.userInteractionEnabled = false
        checkinWarningLabel.hidden = true
        checkInButtonWrapperView.hidden = true
    }
    
    private func classIsStarted() {
        checkInButton.hidden = false
        checkInButtonWrapperView.hidden = false
        checkinWarningLabel.hidden = true
        if displayClass.didStudentAttend(student) {
            print("class \(displayClass.name) is started and student attended")
            checkIntoClassLabel.text = Class.textForStudentClassCheckedIn
            checkInButton.selected = true
            checkInButton.userInteractionEnabled = false
			checkInButton.setBackgroundImage(UIImage(named: "selected_checkin"), forState: .Selected)
        }else{
            print("class \(displayClass.name) is started and student has not attended")
        
			checkInButton.userInteractionEnabled = true
		    if displayClass.isWaitingToAttend {
                // show question mark as status is unknown
                checkInButton.setBackgroundImage(UIImage(named: "unsurequestionmark"), forState: .Normal)
				checkInButton.userInteractionEnabled = false
            }
            checkIntoClassLabel.text = Class.textForStudentClassStarted
            checkInButton.selected = false
        }
    }
    
    func showWarning() {
        checkinWarningLabel.hidden = false
        checkinWarningLabel.text = Class.textForStudentOutsideGeofence
        checkInButton.setImage(UIImage(named: "unsurequestionmark"), forState: .Normal)
    }
    
    @IBAction func checkInButtonActionClicked(sender: AnyObject) {
        print("Sender State \(checkInButton.state)")
        
        // need to remember whether student has tried to check in for class already
    }
}



