//
//  CourseViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController,UINavigationBarDelegate {
    
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
    
    /*  Attendance  */
    /*startButton*/
    @IBOutlet weak var startButton: UIButton!
    
    
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
        
        // store current class
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
    }
    
    func setUpGestures() {
        attendanceTapGestureRecognizer.addTarget(self, action: "attendanceViewClicked")
        questionsTapGestureRecognizer.addTarget(self, action: "questionsViewClicked")
    }
    
    func attendanceViewClicked(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func questionsViewClicked(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
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
