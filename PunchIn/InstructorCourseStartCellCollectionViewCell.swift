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
    
    @IBOutlet weak var checkInStatus: UILabel!
    @IBOutlet weak var checkInButon: UIButton!
    var newInstructorCourseStartDelegate: InstructorCourseStartProtocol?
    
    private var useCurrentLocationToStartClass: Bool = false
    
    private let textForUsingCurrentLocation = "using your current location"
    private let textForNotUsingCurrentLocation = "using the course's registered location"
    
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
        checkInButon.hidden = true
        // TODO: check class location before updating this text since the variable state will be lost
        // useCurrentLocationLabel.text = "Class was started " + useCurrentLocationToStartClass ? textForUsingCurrentLocation :
        // textForNotUsingCurrentLocation
        // useCurrentLocationButton.hidden = true
        // useCurrentLocationLabel.hidden = true
    }
    
    private func classIsStarted() {
        checkInStatus.text = Class.textForInstructorClassStarted
        checkInButon.hidden = false
        checkInButon.selected = true
        // useCurrentLocationLabel.text = "Class was started " + useCurrentLocationToStartClass ? textForUsingCurrentLocation :
        // textForNotUsingCurrentLocation
        // useCurrentLocationButton.hidden = true
        // useCurrentLocationLabel.hidden = false

    }
    
    private func classNotStarted() {
        checkInStatus.text = Class.textForInstructorClassNotStarted
        checkInButon.hidden = false
        checkInButon.selected = false
        // useCurrentLocationLabel.text = "Class was started " + useCurrentLocationToStartClass ? textForUsingCurrentLocation :
        // textForNotUsingCurrentLocation
        // useCurrentLocationButton.hidden = false
        // useCurrentLocationLabel.hidden = false
    }
    
    func setupUI() {
        // button to start the class
        checkInButon.setBackgroundImage(UIImage.init(named:"selected_checkin"), forState: .Selected)
        checkInButon.setBackgroundImage(UIImage.init(named:"unselected_checkin"), forState: .Normal)
        checkInButon.hidden = false
        //checkInStatus.font = ThemeManager.theme().primarySubTitleFont()
        
        // button to use current location
        //useCurrentLocationButton.setImage(UIImage.init(named:"selected_button_login"), forState: .Selected)
        //useCurrentLocationButton.setImage(UIImage.init(named:"unselected_button_login"), forState: .Normal)
        //useCurrentLocationButton.hidden = false

        checkInStatus.textColor = UIColor.whiteColor()
    }
    
    /*
    func setUpCourseStartCell(aCurrentClass:Class){
        checkInButon.setImage(UIImage.init(named:"selected_checkin"), forState: .Selected)
        checkInButon.setImage(UIImage.init(named:"unselected_checkin"), forState: .Normal)
        currentClass = aCurrentClass
        checkInStatus.textColor = UIColor.whiteColor()
        checkInStatus.font = ThemeManager.theme().primarySubTitleFont()
    }
    */
    
    @IBAction func checkInButtonAction(sender: AnyObject) {
        checkInButon.selected = !checkInButon.selected
        startClassTapped()
    }
    
    @IBAction func useCurrentLocationTapped(sender: AnyObject){
        useCurrentLocationToStartClass != useCurrentLocationToStartClass
        // useCurrentLocationButton.selected = useCurrentLocationToStartClass
    }
    
    func startClassTapped() {
        print("tapped start class!")
        
        guard !ParseDB.isStudent else {
            print("students can't start a class")
            let alertController = UIAlertController(
                title: "StudentCantStartClass",
                message: "Students can't start a class",
                preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(dismissAction)
           // self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
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
                    self.newInstructorCourseStartDelegate?.classStarted()
                    self.classIsStarted()
                    print("class \(self.displayClass.name) started!");
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        //           self.startClassView.backgroundColor = UIColor.greenColor()
                        //         self.startClassLabel.text = Class.classStartedText
                    })
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
