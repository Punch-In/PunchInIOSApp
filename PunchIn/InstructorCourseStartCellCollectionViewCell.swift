//
//  InstructorCourseStartCellCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol InstructorCourseStartProtocol {
    func classStarted()
    func classEnded()
}


class InstructorCourseStartCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var checkInStatus: UILabel!
    @IBOutlet private weak var checkInButton: UIButton!
    @IBOutlet private weak var checkInButtonWrapperView: UIView!
    @IBOutlet private weak var useCurrentLocationImageView: UIImageView!
    @IBOutlet weak var useCurrentLocationLabel: UILabel!
    
    var newInstructorCourseStartDelegate: InstructorCourseStartProtocol?
    
    private var useCurrentLocationToStartClass: Bool = false {
        didSet {
            if useCurrentLocationToStartClass {
                useCurrentLocationImageView.image = UIImage(named: "selected_button_login")
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.useCurrentLocationImageView.alpha = 1.0
                    self.useCurrentLocationLabel.text = self.textForUsingCurrentLocation
                })
            }else{
                useCurrentLocationImageView.image = UIImage(named: "unselected_button_login")
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.useCurrentLocationLabel.text = self.textForNotUsingCurrentLocation
                    self.useCurrentLocationImageView.alpha = 0.50
                })
            }
        }
    }
    
    private let textForUsingCurrentLocation = "your current location"
    private let textForNotUsingCurrentLocation = "the course's registered location"
    
    var displayClass : Class! {
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

    private func classIsFinished() {
        checkInStatus.text = Class.textForClassFinished
        checkInButton.hidden = true
        checkInButtonWrapperView.hidden = true
        useCurrentLocationImageView.hidden = true
        useCurrentLocationLabel.hidden = true
    }
    
    private func classIsStarted() {
        checkInStatus.text = Class.textForInstructorClassStarted
        checkInButton.hidden = false
        checkInButton.selected = true
        checkInButtonWrapperView.hidden = false
        if displayClass.isUsingCourseLocation {
            useCurrentLocationLabel.text = "Class is using course's registered location"
        }else{
            useCurrentLocationLabel.text = "Class is using your location, not course location"
        }
        useCurrentLocationImageView.hidden = true
    }
    
    private func classNotStarted() {
        checkInStatus.text = Class.textForInstructorClassNotStarted
        checkInButton.hidden = false
        checkInButton.selected = false
        checkInButtonWrapperView.hidden = false
        useCurrentLocationLabel.text = (useCurrentLocationToStartClass ? textForUsingCurrentLocation : textForNotUsingCurrentLocation)
        useCurrentLocationImageView.hidden = false
        
        let gesture = UITapGestureRecognizer(target: self, action: "useCurrentLocationTapped")
        useCurrentLocationImageView.addGestureRecognizer(gesture)
    }
    
    func setupUI() {
        // button to start the class
        checkInButton.setBackgroundImage(UIImage.init(named:"selected_checkin"), forState: .Selected)
        checkInButton.setBackgroundImage(UIImage.init(named:"unselected_checkin"), forState: .Normal)
        checkInButton.hidden = true
        
        // border
        checkInButton.layer.cornerRadius = 6.0
        checkInButton.clipsToBounds = true
        checkInButtonWrapperView.hidden = true
        checkInButtonWrapperView.layer.cornerRadius = 6.0
        checkInButtonWrapperView.clipsToBounds = true

        
        // button to use current location
        useCurrentLocationImageView.image = UIImage(named: "unselected_button_login")
        useCurrentLocationImageView.alpha = 0.50
        useCurrentLocationImageView.hidden = true
        useCurrentLocationLabel.textColor = UIColor.whiteColor()
        checkInStatus.textColor = UIColor.whiteColor()
    }
    
    
    @IBAction func checkInButtonAction(sender: AnyObject) {
        checkInButton.selected = !checkInButton.selected
        startClassTapped()
    }
    
    func useCurrentLocationTapped(){
        useCurrentLocationToStartClass = !useCurrentLocationToStartClass
    }
    
    func startClassTapped() {
        print("tapped start class!")
        
//        guard !ParseDB.isStudent else {
//            print("students can't start a class")
//            let alertController = UIAlertController(
//                title: "StudentCantStartClass",
//                message: "Students can't start a class",
//                preferredStyle: .Alert)
//            
//            let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alertController.addAction(dismissAction)
//           // self.presentViewController(alertController, animated: true, completion: nil)
//            return
//        }
        
        guard !displayClass.isFinished else {
            // class already done... do nothing
        
            return
        }
        
        if displayClass.isStarted {
            // stop class
            doStopClass()
        }else {
            doStartClass()
        }
    }
    
    private func doStartClass() {
        // TODO: verify class can be started (time, etc) --> alert user if outside of class expected time
        // TODO: verify user can start class
        let hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
        hud.labelText = "Starting class..."
        
        displayClass.start(useCourseLocation: !useCurrentLocationToStartClass){ (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    print("class \(self.displayClass.name) started!");
                    self.newInstructorCourseStartDelegate?.classStarted()
                    self.classIsStarted()
                    MBProgressHUD.hideHUDForView(self, animated: true)
                }
            }else{
                MBProgressHUD.hideHUDForView(self, animated: true)
                print("error getting location for starting class \(error)")
            }
        }
    }
    
    private func doStopClass() {
        displayClass.finish()
        self.newInstructorCourseStartDelegate?.classEnded()
        print("End Class")
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.classIsFinished()
        })
    }
    


}
