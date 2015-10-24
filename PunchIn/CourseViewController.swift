//
//  CourseViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController,UINavigationBarDelegate {
    
    var course:Courses?
    
    /*IgnoreViews*/
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var questionsView: UIView!
    
    @IBOutlet weak var startClassLabel: UILabel!
    @IBOutlet weak var startClassView: UIView!
    /*Course Details*/
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var classNumber: UILabel!
    @IBOutlet weak var courseDate: UILabel!
    @IBOutlet weak var courseAddress: UILabel!

    @IBOutlet var attendanceTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var questionsTapGestureRecognizer: UITapGestureRecognizer!
    
    /*  Attendance  */
    // @IBOutlet weak var totalAttendance: UILabel!
    /*  Questions*/
    //  @IBOutlet weak var unansweredQuestions: UILabel!
    /*startButton*/
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpValues()
    }
    
    
    func setUpValues() {
        /*Setting the class details*/
        courseName.text = course?.courseName
        classNumber.text = course?.classNumber
        courseDate.text = course?.classTimeAndDate
        courseAddress.text = course?.courseAddress
        
        attendanceTapGestureRecognizer.addTarget(self, action: "attendanceViewClicked")
        questionsTapGestureRecognizer.addTarget(self, action: "questionsViewClicked")
    }
    
    func attendanceViewClicked(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
        vc.course = course
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func questionsViewClicked(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController")
    
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
        ThemeManager.theme().themeForTitleLabels(classNumber)
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
