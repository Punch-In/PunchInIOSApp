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
    
    var displayClass : Class! {
        didSet {
            updateCheckInText()
            checkInButon.selected = displayClass.isStarted || displayClass.isFinished
        }
    }

    private func updateCheckInText() {
        if displayClass.isFinished {
            checkInStatus.text = Class.classFinishedText
        }else if displayClass.isStarted {
            checkInStatus.text = Class.classStartedText
        }else{
            checkInStatus.text = Class.classNotStartedText
        }
    }
    
    func setupUI() {
        checkInButon.setImage(UIImage.init(named:"selected_checkin"), forState: .Selected)
        checkInButon.setImage(UIImage.init(named:"unselected_checkin"), forState: .Normal)
        checkInStatus.textColor = UIColor.whiteColor()
        checkInStatus.font = ThemeManager.theme().primarySubTitleFont()
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
        
        displayClass.start { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideHUDForView(self, animated: true)
                    self.newInstructorCourseStartDelegate?.classStarted()
                    self.updateCheckInText()
                    print("Start Class");
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        //           self.startClassView.backgroundColor = UIColor.greenColor()
                        //         self.startClassLabel.text = Class.classStartedText
                    })
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
            // self.startClassLabel.text = Class.classFinishedText
            // self.startClassView.backgroundColor = UIColor.redColor()
        })
    }
    


}
