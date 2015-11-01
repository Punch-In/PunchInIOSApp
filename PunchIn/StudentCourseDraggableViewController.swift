//
//  StudentCourseDraggableViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/28/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class StudentCourseDraggableViewController: UICollectionViewController {

    var course:Course!
    var classIndex:Int!
    var initialCenterPoint:CGPoint?
    var lastCenterPoint:CGPoint?
    private var allowedToCheckIn:Bool?
    let refreshControl = UIRefreshControl()
    //PageController Property.
    var indexNumber:Int!
    @IBOutlet var studentDraggableViewCollectionView: UICollectionView!
    
    /*Start Class*/
    /*Class Details*/
    //private var classIndex: Int!
    private var currentClass: Class!
    
    
    
    
    /* the Student */
    var student: Student!
    
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
        
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "refreshValues", forControlEvents: .ValueChanged)
        studentDraggableViewCollectionView.addSubview(refreshControl)
        studentDraggableViewCollectionView.alwaysBounceVertical = true
    
        resetAttendView()
       // setUpUI()
        setUpValues()
        //setUpGestures()
        setCollectionViewLayout()
        allowedToCheckIn = false
    }
    
    
    func refreshValues (){
        currentClass = course.classes![classIndex]
        
        currentClass.refreshDetails { (error) -> Void in
        if error == nil {
        dispatch_async(dispatch_get_main_queue()){
          //         self.questionCount.hidden = false
         //          self.unansweredQuestionCount.hidden = false
        //           self.questionCount.text = "\(self.currentClass.questions!.count)"
        //           self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
        //           self.attendClassLabel.text = self.currentClass.name
        
        // set "class start" view based on class status
        if self.currentClass.isFinished {
        //        self.imageView3.hidden = true
        }else if self.currentClass.isStarted {
        //        self.imageView3.hidden = false
        //imageView3.backgroundColor = UIColor.greenColor()
        }else {
        //    imageView3.backgroundColor = UIColor.grayColor()
        //         self.imageView3.hidden = true
        }
          self.setupAttendView()
        }
        }
        }
        
        
        student.getImage{ (image, error) -> Void in
        if error == nil {
        dispatch_async(dispatch_get_main_queue()){
        //        self.studentAvatar.alpha = 0
        //        self.studentAvatar.image = image
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
        //           self.studentAvatar.alpha = 1
        })
        }
        }else{
        print("error getting image for student \(self.student.studentName)")
        }
        }
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
        self.navigationController?.pushViewController(vc, animated: true)
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
        attendClassTapped()
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
            print("woo")
        }
    }
    
    func canNotAttendClass() {
        print("student outside the geofence for the class \(currentClass.name) !")
        allowedToCheckIn = false
    }
    
    
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width-20, self.view.bounds.height/5)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        studentDraggableViewCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    
    
    
 // MARK: Collection View Controller Methods : 
   override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4;
    }
    

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell :UICollectionViewCell!
        
        if indexPath.row == 0{
            let checkIncell:CheckInCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CheckInCell", forIndexPath: indexPath) as! CheckInCollectionViewCell
            checkIncell.backgroundColor = ThemeManager.theme().primaryYellowColor()
            checkIncell.setUpUI()
            checkIncell.setUpValuesForCheckIn(currentClass, allowedToCheckIn: allowedToCheckIn!,message: " ")
            return checkIncell;
        }
        if(indexPath.row == 1){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClassNameCell", forIndexPath: indexPath) as! ClassNameCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            cell.layer.borderWidth = 0.5
            
        }
        
        if(indexPath.row == 2){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("AttendanceDisplayCell", forIndexPath: indexPath) as! AttendanceDisplayCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            cell.layer.borderWidth = 0.5
        }
        if(indexPath.row == 3){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionsCell",forIndexPath:indexPath) as! QuestionsCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            cell.layer.borderWidth = 0.5
        }
        return cell;
    }

    
    
    
    
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if(segue.identifier == "DetailAttedanceViewControllerSegue"){
//            //   var vc:
//            
//        }else if(segue.identifier == "QuestionsViewControllerSegue"){
//        }
//    }
//    

    
    
    
    
    
    
    
    
    


    
}
