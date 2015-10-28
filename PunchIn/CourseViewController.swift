//
//  CourseViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class CourseViewController: UIViewController,UINavigationBarDelegate,ClassStartedDelegate {
    
    var course:Course!
    
    /*IgnoreViews*/
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var questionsView: UIView!
    
    @IBOutlet weak var startClassLabel: UILabel!
    @IBOutlet weak var startClassView: UIView!
    
    /*Course Details*/
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var courseDate: UILabel!
    @IBOutlet weak var courseAddress: UILabel!
    
    /* Class Details */
    private var classIndex: Int = 0
    private var currentClass: Class!
    @IBOutlet weak var classDescription: UILabel!
    @IBOutlet weak var registeredCount: UILabel!    
    @IBOutlet weak var attendanceCount: UILabel!
    
    /* Question Details */
    
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var unansweredQuestionCount: UILabel!
    
    @IBOutlet var attendanceTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var questionsTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var startClassTapGestureRecognizer: UITapGestureRecognizer!
    
    /*  Attendance  */
    /*startButton*/
    @IBOutlet weak var startButton: UIButton!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: LocationProvider.locationAvailableNotificationName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpValues()
        setUpGestures()
    }
    
    
    func setUpValues() {
        /*Setting the course details*/
        courseName.text = course.courseName
        courseNumber.text = course.courseId
        courseDate.text = String("\(course.courseTime); \(course.courseDay)")
        courseAddress.text = course.courseLocation.address
        registeredCount.text = "\(course.registeredStudents!.count)"
        
        // show current class
        currentClass = course.classes![classIndex]
        classDescription.text = currentClass.classDescription
        currentClass.fetchAllFields { (theClass, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.attendanceCount.text = "\(self.currentClass.attendance!.count)"
                    self.questionCount.text = "\(self.currentClass.questions!.count)"
                    self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
                }
            }
        }
        
        // set "class start" view based on class status
        if currentClass.isFinished {
            self.startClassLabel.text = Class.classFinishedText
            self.startClassView.backgroundColor = UIColor.redColor()
        }else if currentClass.isStarted {
            self.startClassLabel.text = Class.classStartedText
            self.startClassView.backgroundColor = UIColor.greenColor()
        }else {
            self.startClassLabel.text = Class.classNotStartedText
            ThemeManager.theme().themeForSecondaryContentView(startClassView)
        }
    }
    
    func setUpGestures() {
        attendanceTapGestureRecognizer.addTarget(self, action: "attendanceViewTapped")
        questionsTapGestureRecognizer.addTarget(self, action: "questionsViewTapped")
        startClassTapGestureRecognizer.addTarget(self, action: "startClassTapped")
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
    
    func startClassTapped() {
        print("tapped start class!")

        guard !currentClass.isFinished else {
            // class already done... do nothing
            return
        }
        
        if currentClass.isStarted {
            // stop class
            doStopClass()
        }else {
            doStartClass()
        }
    }

    private func doStartClass() {
        // TODO: verify class can be started (time, etc) --> alert user if outside of class expected time
        // TODO: verify user can start class
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Starting class..."
        
        currentClass.start(self)
    }
    
    // Class started delegate
    func classDidStart(error:NSError?) {
        if error == nil {
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.startClassView.backgroundColor = UIColor.greenColor()
                    self.startClassLabel.text = Class.classStartedText
                })
            }
        }else{
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print("error getting location for starting class \(error)")
        }
    }
    
    private func doStopClass() {
        currentClass.finish()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.startClassLabel.text = Class.classFinishedText
            self.startClassView.backgroundColor = UIColor.redColor()
        })
    }
    
    func setUpUI(){
        //Navigation Controller
        self.navigationController?.navigationBar.barTintColor = ThemeManager.theme().primaryColor()
        self.navigationItem.title = "Course"
        self.navigationController?.navigationItem.title = "Course"
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary.init(dictionary:
            [NSForegroundColorAttributeName:UIColor.whiteColor()]) as? [String : AnyObject]
        
        //Content Views
        ThemeManager.theme().themeForContentView(courseView)
        ThemeManager.theme().themeForContentView(attendanceView)
        ThemeManager.theme().themeForContentView(questionsView)
        ThemeManager.theme().themeForSecondaryContentView(startClassView)
        
        //Labels
        ThemeManager.theme().themeForTitleLabels(courseName)
        ThemeManager.theme().themeForTitleLabels(courseNumber)
        ThemeManager.theme().themeForTitleLabels(courseDate)
        ThemeManager.theme().themeForTitleLabels(courseAddress)
        ThemeManager.theme().themeForTitleLabels(startClassLabel)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if(segue.identifier == "AttedanceViewControllerSegue"){
         //   var vc:
            
        }else if(segue.identifier == "QuestionsViewControllerSegue"){
            
        }
    }
    
    
}
