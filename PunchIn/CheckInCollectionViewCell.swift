
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
    
    
    func setUpUI(){
        checkInButton.imageView?.image = UIImage.init(named: "unselected_checkin")
        checkinWarningLabel.text = ""
        checkIntoClassLabel.text = "Check in to the class"
        checkIntoClassLabel.textColor = UIColor.whiteColor()
        
        self.backgroundColor = ThemeManager.theme().primaryYellowColor()
    }
    
 
    
//    
//    //  MARK: Setup Values
//    func setUpValues(){
//        // show current class
//        currentClass = course.classes![classIndex]
//        currentClass.refreshDetails { (error) -> Void in
//            if error == nil {
//                dispatch_async(dispatch_get_main_queue()){
//                    self.questionCount.hidden = false
//                    self.unansweredQuestionCount.hidden = false
//                    self.questionCount.text = "\(self.currentClass.questions!.count)"
//                    self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
//                    self.attendClassLabel.text = self.currentClass.name
//                    // set "class start" view based on class status
//                    if self.currentClass.isFinished {
//                        self.imageView3.hidden = true
//                    }else if self.currentClass.isStarted {
//                        self.imageView3.hidden = false
//                        //imageView3.backgroundColor = UIColor.greenColor()
//                    }else {
//                        //    imageView3.backgroundColor = UIColor.grayColor()
//                        self.imageView3.hidden = true
//                    }
//                    self.setupAttendView()
//                }
//            }
//        }
//        
//        
//        student.getImage{ (image, error) -> Void in
//            if error == nil {
//                dispatch_async(dispatch_get_main_queue()){
//                    self.studentAvatar.alpha = 0
//                    self.studentAvatar.image = image
//                    UIView.animateWithDuration(0.3, animations: { () -> Void in
//                        self.studentAvatar.alpha = 1
//                    })
//                }
//            }else{
//                print("error getting image for student \(self.student.studentName)")
//            }
//        }
//    }
//    
//    
//    @IBAction func presentAction(sender: UIPanGestureRecognizer) {
//        let translation = sender.translationInView(self.attendClassView)
//        if allowedToCheckIn == true {
//            switch sender.state {
//            case .Began:
//                initialCenterPoint = self.studentAvatar.center
//                lastCenterPoint = self.openDoorImage.center
//            case .Cancelled:
//                fallthrough
//            case .Ended:
//                fallthrough
//            case .Failed:
//                fallthrough
//            case .Possible:
//                fallthrough
//            case .Changed:
//                
//                if(self.studentAvatar.center.x < ((initialCenterPoint?.x)!)  || translation.x < 0){
//                }
//                if (translation.x > 0 && self.studentAvatar.center.x < self.openDoorImage.center.x){
//                    self.studentAvatar.center.x = (initialCenterPoint?.x)! + translation.x
//                }
//                
//                if studentAvatar.center.x > lastCenterPoint?.x {
//                    imageView3.hidden = true
//                    print("Student Attended")
//                    
//                }
//            }
//        }
//    }
//    
//    
//    func setUpUI(){
//        ThemeManager.theme().themeForContentView(questionsView)
//    }
//    
//    func setUpGestures() {
//        questionsTapGestureRecognizer.addTarget(self, action: "questionsViewTapped")
//        startClassTapGestureRecognizer.addTarget(self, action: "attendClassTapped")
//        attendanceTapGestureRecognizer.addTarget(self, action: "attendanceViewTapped")
//    }
//    
//    //Attendance View Tapped.
//    func attendanceViewTapped(){
//        let storyBoardName = "Main"
//        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
//        let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
//        vc.theClass = currentClass
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    //Questions View Tapped.
//    func questionsViewTapped(){
//        let storyBoardName = "Main"
//        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
//        let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
//        vc.theClass = currentClass
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func resetAttendView() {
//        imageView3.hidden = false
//        imageView3.backgroundColor = UIColor.grayColor()
//        self.questionCount.hidden = true
//        self.unansweredQuestionCount.hidden = true
//    }
//    
//    func setupAttendView() {
//        if currentClass.isFinished {
//            allowedToCheckIn = false
//            imageView3.hidden = true
//            print("Class \(currentClass.name) is finished");
//            return
//        }
//        
//        if !currentClass.isStarted {
//            print("class \(currentClass.name) has not started")
//            imageView3.backgroundColor = UIColor.grayColor()
//            allowedToCheckIn = false
//            imageView3.hidden = true
//            return
//        }
//        
//        if self.currentClass.didStudentAttend(student!) {
//            print("Class \(currentClass.name) has started, and student has already attended")
//            self.allowedToCheckIn = false
//            self.imageView3.backgroundColor = UIColor.greenColor()
//            imageView3.hidden = false
//        }else{
//            print("Class \(currentClass.name) has started, but student has not checked in yet")
//            self.allowedToCheckIn = true
//            self.imageView3.backgroundColor = UIColor.redColor()
//            imageView3.hidden = false
//        }
//    }
//    
//    func attendClassTapped() {
//        print("tapped attend class \(currentClass.name)")
//        
//        guard ParseDB.isStudent else {
//            print("instructor can't attend a class")
//            let alertController = UIAlertController(
//                title: "InstructorCantAttendClass",
//                message: "Instructors can't attend a class",
//                preferredStyle: .Alert)
//            
//            let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alertController.addAction(dismissAction)
//            self.presentViewController(alertController, animated: true, completion: nil)
//            return
//        }
//        
//        guard !currentClass.isFinished else {
//            // class already done... do nothing
//            print("class \(currentClass.name) already finished; can't attend")
//            imageView3.hidden = true
//            allowedToCheckIn = false
//            return
//        }
//        
//        guard currentClass.isStarted else {
//            print("class \(currentClass.name) hasn't started yet")
//            imageView3.hidden = true
//            allowedToCheckIn = false
//            imageView3.backgroundColor = UIColor.redColor()
//            return
//        }
//        
//        guard !currentClass.didStudentAttend(student!) else {
//            print("student already attended class \(currentClass.name) ")
//            return
//        }
//        
//        // class has started, check if student is inside geofence
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canAttendClass", name: Class.insideClassGeofenceNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canNotAttendClass", name: Class.outsideClassGeofenceNotification, object: nil)
//        currentClass.notifyWhenStudentCanAttendClass()
//    }
//    
//    func canAttendClass() {
//        print("student can attend class \(currentClass.name)!")
//        self.allowedToCheckIn = true
//        imageView3.backgroundColor = UIColor.greenColor()
//        attendClassView.backgroundColor = UIColor.greenColor()
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.outsideClassGeofenceNotification, object: nil)
//        currentClass.attendClass(self.student) { (confirmed) -> Void in
//            print("woo")
//        }
//    }
//    
//    func canNotAttendClass() {
//        print("student outside the geofence for the class \(currentClass.name) !")
//    }
//    
//    
    
    
    
    
}
