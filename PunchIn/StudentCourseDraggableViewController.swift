//
//  StudentCourseDraggableViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/28/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class StudentCourseDraggableViewController: UICollectionViewController, QuestionPostedNewProtocol {

    var course:Course!
    var classIndex:Int!
    var indexNumber:Int!
    var student: Student!
    
    private var currentClass: Class!
    private var allowedToCheckIn:Bool?
    
    let refreshControl = UIRefreshControl()
    @IBOutlet var studentDraggableViewCollectionView: UICollectionView!
    
    //private var classIndex: Int!
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
        student = ParseDB.currentPerson as! Student
        
        resetAttendView()
        setUpUI()
        setUpGestures()
        setUpValues()
        setCollectionViewLayout()
        allowedToCheckIn = false

        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func setUpUI() {
    
    }
    
    func setUpGestures() {
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: .ValueChanged)
        studentDraggableViewCollectionView.addSubview(refreshControl)
        studentDraggableViewCollectionView.alwaysBounceVertical = true
    }
    
    func fetchData() {
        // referesh class details
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Updating class details..."
        
        currentClass = course.classes![classIndex]
        currentClass.refreshDetails{ (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    // TODO: show class details
                    self.setupAttendView()
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                print("error updating class details! \(error)")
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
        
//        student.getImage{ (image, error) -> Void in
//            if error == nil {
//                dispatch_async(dispatch_get_main_queue()){
//                    //        self.studentAvatar.alpha = 0
//                    //        self.studentAvatar.image = image
//                    
//                    UIView.animateWithDuration(0.3, animations: { () -> Void in
//                        //           self.studentAvatar.alpha = 1
//                    })
//                }
//            }else{
//                print("error getting image for student \(self.student.studentName)")
//            }
//        }

    }
    
    
    func resetAttendView() {
        //        imageView3.hidden = false
        //        imageView3.backgroundColor = UIColor.grayColor()
           //     self.questionCount.hidden = true
            //    self.unansweredQuestionCount.hidden = true
    }

        //  MARK: Setup Values
    func setUpValues(){
        // show current class
        currentClass = course.classes![classIndex]
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
        vc.newQuestionDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPostNewQuestion(question: Question?) {
        let indexPath = NSIndexPath(forRow: 2, inSection: 0)
        if let questionCell = studentDraggableViewCollectionView.cellForItemAtIndexPath(indexPath) as? QuestionsCollectionViewCell {
            // new question created... need to make sure to refresh the count
            questionCell.numQuestions = currentClass.questions!.count
        }
    }

    func setupAttendView() {
        if currentClass.isFinished {
            allowedToCheckIn = false
            print("Class \(currentClass.name) is finished");
            return
        }
        
        if !currentClass.isStarted {
            print("class \(currentClass.name) has not started")
            
            allowedToCheckIn = false
            return
        }
        
        if self.currentClass.didStudentAttend(student!) {
            print("Class \(currentClass.name) has started, and student has already attended")
            self.allowedToCheckIn = false
            
        }else{
            print("Class \(currentClass.name) has started, but student has not checked in yet")
            self.allowedToCheckIn = true
        }
    }
    
    func attendClassTapped() {
        print("tapped attend class \(currentClass.name)")
        
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
            print("class \(currentClass.name) already finished; can't attend")
            allowedToCheckIn = false
            return
        }
        
        guard currentClass.isStarted else {
            print("class \(currentClass.name) hasn't started yet")
            allowedToCheckIn = false
            return
        }
        
        guard !currentClass.didStudentAttend(student!) else {
            print("student already attended class \(currentClass.name) ")
            return
        }
        
        // class has started, check if student is inside geofence
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canAttendClass", name: Class.insideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canNotAttendClass", name: Class.outsideClassGeofenceNotification, object: nil)
        currentClass.notifyWhenStudentCanAttendClass()
        refreshControl.endRefreshing()
        studentDraggableViewCollectionView.reloadData()
    }
        
    func canAttendClass() {
        print("student can attend class \(currentClass.name)!")
        self.allowedToCheckIn = true
       
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.outsideClassGeofenceNotification, object: nil)
        currentClass.attendClass(self.student) { (confirmed) -> Void in
            print("woo \(self.view.window) \(self.view.hidden)")
            if self.view.window == nil {
                // view is currently not visible
                if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
                    // in background... notification
                    print("notification!")
                }else{
                    // assume foreground... alert
                    let alertController = UIAlertController(
                        title: "CheckIn",
                        message: "Woo hoo! You've checked in for class \(self.currentClass.name)",
                        preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func canNotAttendClass() {
        print("student outside the geofence for the class \(currentClass.name) !")
        allowedToCheckIn = false
    }
    
    
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/5)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        studentDraggableViewCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    
    
    
 // MARK: Collection View Controller Methods : 
   override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            questionsViewTapped()
        }
    }
    

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell :UICollectionViewCell!
        
        if indexPath.row == 0{
            let checkIncell:CheckInCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CheckInCell", forIndexPath: indexPath) as! CheckInCollectionViewCell
            checkIncell.backgroundColor = ThemeManager.theme().primaryYellowColor()
            checkIncell.setUpUI()
            checkIncell.setUpValuesForCheckIn(currentClass, allowedToCheckIn: allowedToCheckIn!,message: " ")
            
            // for now
            let gesture = UITapGestureRecognizer(target: self, action: "attendClassTapped")
            checkIncell.checkIntoClassLabel.addGestureRecognizer(gesture)
            checkIncell.checkIntoClassLabel.userInteractionEnabled = true
            
            return checkIncell;
        }
        
        if(indexPath.row == 1){
            let  classNameCell:ClassNameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ClassNameCell", forIndexPath: indexPath) as! ClassNameCollectionViewCell
            classNameCell.backgroundColor = UIColor.whiteColor()
            classNameCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            classNameCell.layer.borderWidth = 0.5
            classNameCell.setUpclassCell()
            classNameCell.displayClass = currentClass
            return classNameCell
        }
        
        if(indexPath.row == 2){
            let questionCell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionsCell",forIndexPath:indexPath) as! QuestionsCollectionViewCell
            questionCell.backgroundColor = UIColor.whiteColor()
            questionCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            questionCell.layer.borderWidth = 0.5
            questionCell.setupUI()
            questionCell.numQuestions = currentClass.questions!.count
            
            return questionCell
        }
        return cell;
    }
    
    // MARK: show map view
    @IBAction func mapButtonTapped(sender: AnyObject) {
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ClassMapViewController") as! ClassMapViewController
        vc.currentClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
