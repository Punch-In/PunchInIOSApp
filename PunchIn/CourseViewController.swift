//
//  CourseViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class CourseViewController: UIViewController,UINavigationBarDelegate,UIPageViewControllerDataSource {
    
    var course:Course!
    var startIndex: Int?
    var pageController:UIPageViewController!
    
    @IBOutlet weak var courseBaseView:UIView!
    
    /*IgnoreViews*/
    @IBOutlet weak var courseView: UIView!
    
    
    /*Course Details*/
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var courseDate: UILabel!
    @IBOutlet weak var courseAddress: UILabel!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var instructorNameLabel: UILabel!
    
    /*  Attendance  */
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: LocationProvider.locationAvailableNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpValues()
        setUpPageViewController()
    }
    
    func setUpValues() {
        /*Setting the course details*/
        courseName.text = course.courseName
        courseNumber.text = course.courseId
        courseDate.text = String("\(course.courseTime)\n\(course.courseDay)")
        courseAddress.text = course.courseLocation.address
        
        // format address... ugly for now
        let address = course.courseLocation.address
        if let commaLoc = address.characters.indexOf(",") {
            let newAddr = address.substringToIndex(commaLoc) + "\n" + address.substringFromIndex(commaLoc.advancedBy(2))
            courseAddress.text = newAddr
        }
        
//        course.getImage { (image, error) -> Void in
//            if error == nil {
//                self.courseImageView.alpha = 0.0
//                self.courseImageView.image = image
//                UIView.animateWithDuration(0.2, animations: { () -> Void in
//                    self.courseImageView.alpha = 1.0
//                })
//            }
//        }
        
        course.instructors { (instructors, error) -> Void in
            if let instructors = instructors {
                let instructor = instructors[0]
                instructor.getImage({ (image, error) -> Void in
                    self.courseImageView.alpha = 0.0
                    self.courseImageView.image = image
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.courseImageView.alpha = 1.0
                        self.instructorNameLabel.text = instructor.instructorName
                    })
                })
            }
        }
    }
    
    func setUpUI(){
        //Navigation Controller
        self.navigationController?.navigationBar.barTintColor = ThemeManager.theme().primaryDarkBlueColor()
        self.navigationItem.title = "Course"
        self.navigationController?.navigationItem.title = "Course"
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary.init(dictionary:
            [NSForegroundColorAttributeName:UIColor.whiteColor()]) as? [String : AnyObject]
 
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //Content Views
        ThemeManager.theme().themeForContentView(courseView)
 
        courseView.backgroundColor = ThemeManager.theme().primaryBlueColor()
        courseName.textColor = UIColor.whiteColor()
        
        courseNumber.textColor = UIColor.whiteColor()
        
        courseDate.textColor = UIColor.whiteColor()
        
        courseAddress.textColor = UIColor.whiteColor()
        
        self.instructorNameLabel.textColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Page Controller Methods 
    func setUpPageViewController(){
        
        self.pageController = UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil);
        
        self.pageController.dataSource = self
        
        self.pageController.view.frame = self.courseBaseView.bounds
        
        
        // check if should go to specific starting class
        var index: Int?
        if startIndex == nil {
        // pick starting class: the first class that has not already finished
            index = course.classes?.indexOf{ !$0.isFinished }
            if index == nil {
                // all classes finished for the course
                index = 0
            }
        }else{
            index = startIndex
        }
        
        let viewControllerObject:UIViewController = self.viewControllerAtIndex(withIndex:index!)
        let viewcontrollers:[UIViewController] = [viewControllerObject]
        
        self.pageController.setViewControllers(viewcontrollers, direction: UIPageViewControllerNavigationDirection.Forward, animated:false, completion:nil)
        self.addChildViewController(self.pageController)
        self.courseBaseView.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        var index:Int!
        
        if !ParseDB.isStudent{
            let instructorDraggableView =  viewController as! InstructorDraggableCollectionViewController
            index = instructorDraggableView.indexNumber
        }else{
            let studentDraggableView = viewController as! StudentCourseDraggableViewController
            index = studentDraggableView.indexNumber
        }

        index = index - 1
        if(index < 0){
            return nil
        }
        return self.viewControllerAtIndex(withIndex:index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
        var index:Int!
        
        if !ParseDB.isStudent{
           let instructorDraggableView =  viewController as! InstructorDraggableCollectionViewController
           index = instructorDraggableView.indexNumber
        }else{
            let studentDraggableView = viewController as! StudentCourseDraggableViewController
            index = studentDraggableView.indexNumber
        }
    
        index = index + 1
        if(index  >= course.classes?.count){
            return nil
        }
        
        return self.viewControllerAtIndex(withIndex:index)

    }
    
    func viewControllerAtIndex(withIndex index:Int)->UIViewController{
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        
        if !ParseDB.isStudent {
            let   childViewController   = storyBoard.instantiateViewControllerWithIdentifier("DraggableView") as! InstructorDraggableCollectionViewController
            childViewController.indexNumber = index
            childViewController.course = course
            childViewController.classIndex = index
            return childViewController
        }else{
            let childViewController = storyBoard.instantiateViewControllerWithIdentifier("StudentDraggableView") as! StudentCourseDraggableViewController
            childViewController.indexNumber = index
            childViewController.course = course
            childViewController.classIndex = index
            return childViewController
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int{
        return (course.classes?.count)!
    }// The number of items reflected in the page indicator.
//
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int{
//        let classCount : Int  = (course.classes?.count)!
//        return classCount / 2 
//    }// The selected item reflected in the page indicator.
    
    
    
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
