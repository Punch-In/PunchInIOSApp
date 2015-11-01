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
    var allowedToCheckIn:Bool?
    //PageController Property.
        var indexNumber:Int!
    
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
        
        resetAttendView()
        setUpUI()
       
        setUpGestures()
    
        allowedToCheckIn = false
    }
    
    

    func setUpUI(){
     }
    
    func setUpGestures() {
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
    
    func resetAttendView() {
        
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
    }
    
    
    
    
 // MARK: Collection View Controller Methods : 
   override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1;
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell :UICollectionViewCell!
        
        if indexPath.row == 0{
         cell = collectionView.dequeueReusableCellWithReuseIdentifier("CheckInCell", forIndexPath: indexPath) as! CheckInCollectionViewCell
            return cell;
        }
        if(indexPath.row == 1){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClassNameCell", forIndexPath: indexPath) as! ClassNameCollectionViewCell
            return cell
        }
        
        if(indexPath.row == 2){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("AttendanceCell", forIndexPath: indexPath) as! AttendanceCollectionViewCell
            return cell
        }
        if(indexPath.row == 3){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionsCell",forIndexPath:indexPath) as! QuestionsCollectionViewCell
            return cell
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
