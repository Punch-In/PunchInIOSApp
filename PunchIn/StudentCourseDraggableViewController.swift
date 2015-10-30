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
    var initialCenterPoint:CGPoint?
    var lastCenterPoint:CGPoint?
    var allowedToCheckIn:Bool?
    
    /*Start Class*/
    @IBOutlet var startClassTapGestureRecognizer: UITapGestureRecognizer!
    /*Class Details*/
    //private var classIndex: Int!
    private var currentClass: Class!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.outsideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
    }
        
    // MARK: Init Methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: View Controller Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpValues()
        setUpGestures()
        imageView1.backgroundColor = UIColor.orangeColor()
        imageView2.backgroundColor = UIColor.blueColor()
        imageView3.backgroundColor = UIColor.grayColor()
        setupAttendView()
        allowedToCheckIn = false
    }
    
    //  MARK: Setup Values
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

        // set "class start" view based on class status
        if currentClass.isFinished {
           imageView3.hidden = true
        }else if currentClass.isStarted {
            imageView3.backgroundColor = UIColor.greenColor()
        }else {
            imageView3.backgroundColor = UIColor.grayColor()
        }
        
    }
    

    @IBAction func presentAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.attendClassView)
        let location = sender.locationInView(attendClassView)
        if allowedToCheckIn == true {
        switch sender.state {
        case .Began:
            initialCenterPoint = self.imageView1.center
            lastCenterPoint = self.imageView2.center
        case .Cancelled:
            fallthrough
        case .Ended:
            fallthrough
        case .Failed:
            fallthrough
        case .Possible:
            fallthrough
        case .Changed:
            
            if(self.imageView1.center.x < ((initialCenterPoint?.x)!)  || translation.x < 0){
            }
            if (translation.x > 0 && self.imageView1.center.x < self.imageView2.center.x){
            self.imageView1.center.x = (initialCenterPoint?.x)! + translation.x
            }
        }
        }
    }
    
    
    
    func setUpUI(){
          ThemeManager.theme().themeForContentView(questionsView)
    }
    
    func setUpGestures() {
        questionsTapGestureRecognizer.addTarget(self, action: "questionsViewTapped")
        startClassTapGestureRecognizer.addTarget(self, action: "attendClassTapped")
    }
    
    //Attendance View Tapped.
    func attendanceViewTapped(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Questions View Tapped.
    func questionsViewTapped(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupAttendView() {
        if currentClass.isFinished {
            imageView3.hidden = true
            attendClassView.backgroundColor = UIColor.redColor()
            return
        }
        
        if !currentClass.isStarted {
            imageView1.backgroundColor = UIColor.grayColor()
            imageView2.backgroundColor = UIColor.grayColor()
            imageView3.backgroundColor =
            UIColor.grayColor()
            allowedToCheckIn = false
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
            imageView3.hidden = true
            return
        }
        
        guard currentClass.isStarted else {
            print("class hasn't started yet")
            imageView3.hidden = false
            imageView3.backgroundColor = UIColor.redColor()
            return
        }
        
        guard !currentClass.didStudentAttend(student!) else {
            print("student already attended class")
            return
        }
        
        // class has started, check if student is inside geofence
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canAttendClass", name: Class.insideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canNotAttendClass", name: Class.outsideClassGeofenceNotification, object: nil)
        currentClass.notifyWhenStudentCanAttendClass()
    }
    
    func canAttendClass() {
        print("student can attend class!")
        imageView3.backgroundColor = UIColor.greenColor()
        allowedToCheckIn = true
        attendClassView.backgroundColor = UIColor.greenColor()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.outsideClassGeofenceNotification, object: nil)
        currentClass.attendClass(self.student) { (confirmed) -> Void in
            print("woo")
        }
    }
    
    func canNotAttendClass() {
        print("student outside the geofence for the class!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "DetailAttedanceViewControllerSegue"){
            //   var vc:
            
        }else if(segue.identifier == "QuestionsViewControllerSegue"){
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
