//
//  StudentCourseDraggableViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/28/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class StudentCourseDraggableViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,QuestionPostedNewProtocol, CheckInCollectionViewCellDelegate{

    private enum CollectionViewCellIndex : Int {
        case CheckInCell = 0
        case ClassInfoCell = 1
        case QuestionsCell = 2
    }
    
    var course:Course!
    var classIndex:Int!
    var indexNumber:Int!
    var student: Student!
    
    private var currentClass: Class!
    
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
        
        setUpUI()
        setUpGestures()
        setUpValues()
        setCollectionViewLayout()

        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    private func setUpUI() {
    
    }
    
    private func setUpGestures() {
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
                    self.refreshControl.endRefreshing()
                    self.studentDraggableViewCollectionView.reloadData()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                print("error updating class details! \(error)")
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
    }
    
    //  MARK: Setup Values
    private func setUpValues(){
        // show current class
        currentClass = course.classes![classIndex]
    }

    
    //Attendance View Tapped.
    private func attendanceViewTapped(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
        vc.theClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Questions View Tapped.
    private func questionsViewTapped(){
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
        vc.theClass = currentClass
        vc.newQuestionDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPostNewQuestion(question: Question?) {
        let indexPath = NSIndexPath(forRow: CollectionViewCellIndex.QuestionsCell.rawValue, inSection: 0)
        if let questionCell = studentDraggableViewCollectionView.cellForItemAtIndexPath(indexPath) as? QuestionsCollectionViewCell {
            // new question created... need to make sure to refresh the count
            questionCell.numQuestions = currentClass.questions!.count
        }
    }
    
    private func setCollectionViewLayout(){
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
        guard let cellIndex = CollectionViewCellIndex(rawValue: indexPath.row) else {
            // ???
            print("tapped row: \(indexPath.row)")
            return
        }

        switch cellIndex {
        case .CheckInCell:
//            attendClassTapped()
            break
        case .ClassInfoCell:
//            attendanceViewTapped()
            break
        case .QuestionsCell:
            questionsViewTapped()
        }
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        let defaultSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/5)
        guard let cellIndex = CollectionViewCellIndex(rawValue: indexPath.row) else {
            // ???
            print("size for row: \(indexPath.row)")
            return defaultSize
        }

        switch cellIndex  {
        case .CheckInCell:
            if currentClass.isFinished || !currentClass.isStarted {
                return CGSizeMake(self.view.bounds.size.width, 60)
            }else{
                return CGSizeMake(self.view.bounds.size.width,90)
            }
        case .ClassInfoCell:
            let height = getStringHeight(currentClass.classDescription, fontSize: CGFloat(13.0), width: self.view.bounds.size.width) + 50
            return CGSizeMake(self.view.bounds.size.width, height)

            /*
            if(self.currentClass.classDescription.characters.count < 200){
                CGSizeMake(self.view.bounds.size.width,100)
            }else if(self.currentClass.classDescription.characters.count > 200 && self.currentClass.classDescription.characters.count < 250){
                return CGSizeMake(self.view.bounds.size.width,130)
            }else if(self.currentClass.classDescription.characters.count > 250 && self.currentClass.classDescription.characters.count < 300){
                return CGSizeMake(self.view.bounds.size.width,160)
            }else if(self.currentClass.classDescription.characters.count > 300 && self.currentClass.classDescription.characters.count < 350){
                return CGSizeMake(self.view.bounds.size.width,190)
            }
            */
        case .QuestionsCell:
            return CGSizeMake(self.view.bounds.width, 75)
        }
    }
    
    private func getStringHeight(mytext: String, fontSize: CGFloat, width: CGFloat)->CGFloat {
        
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let attributes = [NSFontAttributeName:font]
        //            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = mytext as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        guard let cellIndex = CollectionViewCellIndex(rawValue: indexPath.row) else {
            print("cell for index path \(indexPath.row) unknown")
            // ???
            return UICollectionViewCell()
        }
        
        switch cellIndex {
        case .CheckInCell:
            let checkIncell:CheckInCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CheckInCell", forIndexPath: indexPath) as! CheckInCollectionViewCell
            checkIncell.backgroundColor = ThemeManager.theme().primaryYellowColor()
            checkIncell.setUpUI()
            checkIncell.student = student
            checkIncell.tapCheckInDelegate = self
            checkIncell.displayClass = currentClass
            return checkIncell;
        case .ClassInfoCell:
            let  classNameCell:ClassNameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ClassNameCell", forIndexPath: indexPath) as! ClassNameCollectionViewCell
            classNameCell.backgroundColor = UIColor.whiteColor()
            classNameCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            classNameCell.layer.borderWidth = 0.5
            classNameCell.setUpclassCell()
            classNameCell.displayClass = currentClass
            self.studentDraggableViewCollectionView.collectionViewLayout.invalidateLayout()
            return classNameCell
        case .QuestionsCell:
            let questionCell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionsCell",forIndexPath:indexPath) as! QuestionsCollectionViewCell
            questionCell.backgroundColor = UIColor.whiteColor()
            questionCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            questionCell.layer.borderWidth = 0.5
            questionCell.setupUI()
            questionCell.numQuestions = currentClass.questions!.count

            return questionCell
        }
        
    }
    
    // MARK: show map view
    @IBAction func mapButtonTapped(sender: AnyObject) {
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ClassMapViewController") as! ClassMapViewController
        vc.currentClass = currentClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: check in functionality
    func didTapCheckIn(cell: CheckInCollectionViewCell) {
        if cell.displayClass != currentClass {
            print("tapped check in for cell that is not the current cell?")
        }
        attendClassTapped()
    }
    
    private func attendClassTapped() {
        print("tapped attend class \(currentClass.name)")
        
        guard !currentClass.isFinished else {
            // class already done... do nothing
            print("class \(currentClass.name) already finished; can't attend")
            return
        }
        
        guard currentClass.isStarted else {
            print("class \(currentClass.name) hasn't started yet")
            return
        }
        
        guard !currentClass.didStudentAttend(student!) else {
            print("student already attended class \(currentClass.name) ")
            return
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Trying to check in...."
        // class has started, check if student is inside geofence
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "allowedToAttendClass", name: Class.insideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "canNotAttendClass", name: Class.outsideClassGeofenceNotification, object: nil)
        currentClass.notifyWhenStudentCanAttendClass()
        studentDraggableViewCollectionView.reloadData()
    }
    
    func allowedToAttendClass() {
        print("student can attend class \(currentClass.name)!")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.insideClassGeofenceNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Class.outsideClassGeofenceNotification, object: nil)
        currentClass.attendClass(self.student) { (confirmed) -> Void in
            if confirmed {
                print("woo")
                if UIApplication.sharedApplication().applicationState != UIApplicationState.Active {
                    // in background... notification
                    print(" \(UIApplication.sharedApplication().applicationState.rawValue) notification!")
                    return
                }
                
                if self.view.window == nil {
                    // view is currently not visible
                    // assume foreground... alert
                    let alertController = UIAlertController(
                        title: "CheckIn",
                        message: "\(self.student.studentName), you've checked in for class \(self.currentClass.name)",
                        preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "Woo Hoo", style: .Default, handler: nil)
                    alertController.addAction(okAction)
                    
                    if let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
                        var topVC = rootVC
                        while (topVC.presentedViewController != nil) {
                            topVC = topVC.presentedViewController!;
                        }
                        topVC.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                    //self.presentViewController(alertController, animated: true, completion: nil)
    //                if let currentVC = UIApplication.sharedApplication().delegate?.window??.rootViewController {
    //                    currentVC.presentViewController(alertController, animated: true, completion: nil)
    //                }
                }
            }else{
                print("attendClass not confirmed!")
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.studentDraggableViewCollectionView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
    }
    
    func canNotAttendClass() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        print("student outside the geofence for the class \(currentClass.name) !")
        // need to update the cell somehow
        
        if let checkInCell = studentDraggableViewCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: CollectionViewCellIndex.CheckInCell.rawValue, inSection: 0)) as? CheckInCollectionViewCell {
            checkInCell.showWarning()
        }else{
            print("couldn't get checkin cell!")
        }
    }
    
}
