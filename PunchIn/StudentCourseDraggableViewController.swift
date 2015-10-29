//
//  StudentCourseDraggableViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/28/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class StudentCourseDraggableViewController: UIViewController {

    var course:Course!
    var classIndex:Int!
    /*Start Class*/
    
    @IBOutlet var startClassTapGestureRecognizer: UITapGestureRecognizer!
    /*Class Details*/
    //private var classIndex: Int!
    private var currentClass: Class!
    @IBOutlet var attendanceTapGestureRecognizer: UITapGestureRecognizer!
    
    /* Question Details */
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var unansweredQuestionCount: UILabel!
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet var questionsTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var attendClassView: UIView!
    //PageController Property.
    var indexNumber:Int!
    
    private var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpValues()
        setUpGestures()
        
        setupAttendView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpValues(){
        course.classes?.count
        // show current class
        if classIndex < 0 {
            classIndex = 0
        }else if classIndex >= course.classes!.count {
            classIndex = course.classes!.count-1
        }
        
        currentClass = course.classes![classIndex]
        

        currentClass.refreshDetails { (theClass, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                
                    self.questionCount.text = "\(self.currentClass.questions!.count)"
                    self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
                }
            }
        }
        
//        // set "class start" view based on class status
//        if currentClass.isFinished {
//            self.startClassLabel.text = Class.classFinishedText
//            self.startClassView.backgroundColor = UIColor.redColor()
//        }else if currentClass.isStarted {
//            self.startClassLabel.text = Class.classStartedText
//            self.startClassView.backgroundColor = UIColor.greenColor()
//        }else {
//            self.startClassLabel.text = Class.classNotStartedText
//            ThemeManager.theme().themeForSecondaryContentView(startClassView)
//        }
//        
    }
    func setUpUI(){
//        ThemeManager.theme().themeForContentView(attendanceView)
        ThemeManager.theme().themeForContentView(questionsView)
       
    }
    
    func setUpGestures() {
//        attendanceTapGestureRecognizer.addTarget(self, action: "attendanceViewTapped")
        questionsTapGestureRecognizer.addTarget(self, action: "questionsViewTapped")
        startClassTapGestureRecognizer.addTarget(self, action: "attendClassTapped")
    }
    
    func attendanceViewTapped(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func questionsViewTapped(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupAttendView() {
        if currentClass.isFinished {
            attendClassView.backgroundColor = UIColor.redColor()
            return
        }
        
        if !currentClass.isStarted {
            attendClassView.backgroundColor = UIColor.grayColor()
            return
        }
        
       ParseDB.student { (student, error) -> Void in
            self.student = student
            if self.currentClass.didStudentAttend(student!) {
                self.attendClassView.backgroundColor = UIColor.greenColor()
            }else{
                self.attendClassView.backgroundColor = UIColor.yellowColor()
                
            }
        }
    }
    
    func attendClassTapped() {
        print("tapped attend class!")
        
        guard ParseDB.isStudent else {
            print("instructor can't attend a class")
            let alertController = UIAlertController(
                title: "InstructorCantAttendClass",
                message: "Instructors can't attend a class",
                preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        guard !currentClass.isFinished else {
            // class already done... do nothing
            print("class already finished; can't attend")
            return
        }
        
        guard currentClass.isStarted else {
            print("class hasn't started yet")
            return
        }
        
        // class has started
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "attendanceNotification", name: Class.insideClassGeofenceNotification, object: nil)
        currentClass.notifyWhenStudentCanAttendClass()
    }
    
    func attendanceNotification() {
        print("student can attend class!")
        attendClassView.backgroundColor = UIColor.greenColor()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
        currentClass.attendClass(self.student) { (confirmed) -> Void in
            print("woo")
        }
    }
    
    
    private func doStartClass() {
        // TODO: verify class can be started (time, etc) --> alert user if outside of class expected time
        // TODO: verify user can start class
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Starting class..."
        
        currentClass.start { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
//                        self.startClassView.backgroundColor = UIColor.greenColor()
//                        self.startClassLabel.text = Class.classStartedText
                    })
                }
            }else{
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                print("error getting location for starting class \(error)")
            }
        }
    }
    
    private func doStopClass() {
        currentClass.finish()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.startClassLabel.text = Class.classFinishedText
//            self.startClassView.backgroundColor = UIColor.redColor()
        })
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "DetailAttedanceViewControllerSegue"){
            //   var vc:
            
        }else if(segue.identifier == "QuestionsViewControllerSegue"){
            
        }
    }
    

    
    
    

    
}
