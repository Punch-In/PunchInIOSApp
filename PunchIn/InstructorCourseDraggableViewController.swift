//
//  InstructorCourseDraggableViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/28/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class InstructorCourseDraggableViewController: UIViewController {
    
    
    var course:Course!
    var classIndex:Int!
    /*Start Class*/
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startClassView: UIView!
    @IBOutlet weak var startClassLabel: UILabel!
    @IBOutlet var startClassTapGestureRecognizer: UITapGestureRecognizer!
    /*Class Details*/
    //private var classIndex: Int!
    private var currentClass: Class!
    @IBOutlet weak var classDescription: UILabel!
    @IBOutlet weak var registeredCount: UILabel!
    @IBOutlet weak var attendanceCount: UILabel!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet var attendanceTapGestureRecognizer: UITapGestureRecognizer!
    /* Question Details */
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var unansweredQuestionCount: UILabel!
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet var questionsTapGestureRecognizer: UITapGestureRecognizer!
    
    /* the Instructor */
    var instructor:Instructor!
    
    //PageController Property.
    var indexNumber:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instructor = ParseDB.currentPerson as! Instructor
        
        setUpUI()
        setUpValues()
        setUpGestures()
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
        return
        }
        currentClass = course.classes![classIndex]
        
        classDescription.text = currentClass.classDescription
        currentClass.refreshDetails { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.attendanceCount.text = "\(self.currentClass.attendance!.count)"
                    self.questionCount.text = "\(self.currentClass.questions!.count)"
                    self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
                    
                    // set "class start" view based on class status
                    if self.currentClass.isFinished {
                        self.startClassLabel.text = Class.classFinishedText
                        self.startClassView.backgroundColor = UIColor.redColor()
                    }else if self.currentClass.isStarted {
                        self.startClassLabel.text = Class.classStartedText
                        self.startClassView.backgroundColor = UIColor.greenColor()
                    }else {
                        self.startClassLabel.text = Class.classNotStartedText
                        ThemeManager.theme().themeForSecondaryContentView(self.startClassView)
                    }
                }
            }
        }
    }
    func setUpUI(){
        ThemeManager.theme().themeForContentView(attendanceView)
        ThemeManager.theme().themeForContentView(questionsView)
        ThemeManager.theme().themeForSecondaryContentView(startClassView)
        
        //Labels
     
        ThemeManager.theme().themeForTitleLabels(startClassLabel)
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
        
        guard !ParseDB.isStudent else {
            print("students can't start a class")
            let alertController = UIAlertController(
                title: "StudentCantStartClass",
                message: "Students can't start a class",
                preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
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
        
        currentClass.start { (error) -> Void in
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
    }
    
    private func doStopClass() {
        currentClass.finish()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.startClassLabel.text = Class.classFinishedText
            self.startClassView.backgroundColor = UIColor.redColor()
        })
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "AttedanceViewControllerSegue"){
            //   var vc:
            
        }else if(segue.identifier == "QuestionsViewControllerSegue"){
            
        }
    }
    
}
