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
    /*Course Details*/
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var classNumber: UILabel!
    @IBOutlet weak var courseDate: UILabel!
    @IBOutlet weak var courseAddress: UILabel!
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
    }
    
    func setUpUI(){
        //Navigation Controller
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.988, green:0.702, blue:0.078, alpha:1.0)
        self.navigationItem.title = "Course"
        self.navigationController?.navigationItem.title = "Course"
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary.init(dictionary:
            [NSForegroundColorAttributeName:UIColor.whiteColor()]) as? [String : AnyObject]

        //Content Views
        ThemeManager.theme().themeForContentView(courseView)
        ThemeManager.theme().themeForContentView(attendanceView)
        ThemeManager.theme().themeForContentView(questionsView)
        //Title Labels
        ThemeManager.theme().themeForLightTitleLabels(courseName)
        ThemeManager.theme().themeForLightTitleLabels(classNumber)
        ThemeManager.theme().themeForLightTitleLabels(courseDate)
        ThemeManager.theme().themeForLightTitleLabels(courseAddress)
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
        if(segue.identifier == ""){
         //   var vc:
        }
    }
    
    
}
