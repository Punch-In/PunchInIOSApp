//
//  InstructorDraggableCollectionViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD


class InstructorDraggableCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, QuestionPostedNewProtocol {

    private enum CollectionViewCellIndex : Int {
        case CheckInCell = 0
        case ClassInfoCell = 1
        case AttendanceCell = 2
        case QuestionsCell = 3
    }
    
    var course:Course!
    var classIndex:Int!
    var indexNumber:Int!
    private var currentClass: Class!
    let refreshControl = UIRefreshControl()
    @IBOutlet var instructorDraggableCollectionView: UICollectionView!
    @IBOutlet weak var mapButton: UIButton!
    
    // MARK: Init Methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGestures()
        setUpValues()
        setCollectionViewLayout()
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setUpGestures() {
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: .ValueChanged)
        instructorDraggableCollectionView.addSubview(refreshControl)
        instructorDraggableCollectionView.alwaysBounceVertical = true
        instructorDraggableCollectionView.backgroundColor = UIColor.whiteColor()        
    }
    
    //  MARK: Setup Values
    private func setUpValues(){
        // show current class
        currentClass = course.classes![classIndex]
    }

    func fetchData(){
        // show current class
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Updating class details...."
        
        currentClass = course.classes![classIndex]
        currentClass.refreshDetails { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.instructorDraggableCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                print("error updating class details! \(error)")
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    private func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/6)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        instructorDraggableCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let defaultSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.height/5)
        
        guard let cellIndex = CollectionViewCellIndex(rawValue: indexPath.row) else {
            print("did size for cell for index path \(indexPath.row)")
            return defaultSize
        }

        switch cellIndex {
        case .CheckInCell:
            if currentClass.isFinished {
                return CGSizeMake(self.view.bounds.size.width, 60)
            }else{
                return CGSizeMake(self.view.bounds.size.width,90)
            }
        case .ClassInfoCell:
            let height = getStringHeight(currentClass.classDescription, fontSize: CGFloat(13.0), width: self.view.bounds.size.width) + 50
            return CGSizeMake(self.view.bounds.size.width, height)
            
            /*
            if(count < 200){
                return CGSizeMake(self.view.bounds.size.width,90)
            }else{
                let height = ((count-200)/50 + 1) * 30 + 90
                return CGSizeMake(self.view.bounds.size.width, CGFloat(height))
            }
            if(self.currentClass.classDescription.characters.count > 200 && self.currentClass.classDescription.characters.count < 250){
                return CGSizeMake(self.view.bounds.size.width,130)
            }else if(self.currentClass.classDescription.characters.count > 250 && self.currentClass.classDescription.characters.count < 300){
                return CGSizeMake(self.view.bounds.size.width,160)
            }else if(self.currentClass.classDescription.characters.count > 300 && self.currentClass.classDescription.characters.count < 350){
                return CGSizeMake(self.view.bounds.size.width,190)
            }else{
                return CGSizeMake(self.view.bounds.size.width,220)
            }
            */
        case .AttendanceCell:
            return CGSizeMake(self.view.bounds.width, 75)
        case .QuestionsCell:
            return CGSizeMake(self.view.bounds.width,75)
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
    
    
    private func classStarted(){
        refreshControl.endRefreshing()
    }
    
    private func classEnded(){
        refreshControl.endRefreshing()
    }
    
    // MARK: Collection View Controller Methods :
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4

    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cellIndex = CollectionViewCellIndex(rawValue: indexPath.row) else {
            print("did select cell for index path \(indexPath.row)")
            return
        }

        switch cellIndex {
        case .AttendanceCell:
            let storyBoardName = "Main"
            let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
            let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
            vc.theClass = currentClass
            self.navigationController?.pushViewController(vc, animated: true)
        case .QuestionsCell:
            let storyBoardName = "Main"
            let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
            let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
            vc.theClass = currentClass
            vc.newQuestionDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break // do nothing
        }
    }
    
    func didPostNewQuestion(question: Question?) {
        let indexPath = NSIndexPath(forRow: CollectionViewCellIndex.QuestionsCell.rawValue, inSection: 0)
        if let questionCell = instructorDraggableCollectionView.cellForItemAtIndexPath(indexPath) as? InstructorQuestionCollectionViewCell {
            // new question created... need to make sure to refresh the count
            questionCell.displayClass = currentClass
        }
    }

    
    /*
    self.attendanceCount.text = "\(self.currentClass.attendance!.count)"
    self.questionCount.text = "\(self.currentClass.questions!.count)"
    self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
    */
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        guard let cellIndex = CollectionViewCellIndex(rawValue: indexPath.row) else {
            print("asking for cell for index path \(indexPath.row)")
            return UICollectionViewCell()
        }
        
        switch cellIndex {
        case .CheckInCell:
            let checkIncell:InstructorCourseStartCellCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorCourseCheckInCell", forIndexPath: indexPath) as! InstructorCourseStartCellCollectionViewCell
            checkIncell.backgroundColor = ThemeManager.theme().primaryYellowColor()
            checkIncell.setupUI()
            checkIncell.displayClass = currentClass
            return checkIncell;
        case .ClassInfoCell:
            let  cell:InstructorCourseNameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorCourseNameCell", forIndexPath: indexPath) as! InstructorCourseNameCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.setupUI()
            cell.displayClass = currentClass
            return cell
        case .AttendanceCell:
            let attendanceCell:InstructorAttendanceCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorAttendanceCell",forIndexPath:indexPath) as! InstructorAttendanceCollectionViewCell
            
            attendanceCell.backgroundColor = UIColor.whiteColor()
            attendanceCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            attendanceCell.layer.borderWidth = 0.5
            attendanceCell.setupUI()
            attendanceCell.displayClass = currentClass
            return attendanceCell
        case .QuestionsCell:
            let questionCell:InstructorQuestionCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorQuestionsCell",forIndexPath:indexPath) as! InstructorQuestionCollectionViewCell
            questionCell.backgroundColor = UIColor.whiteColor()
            questionCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            questionCell.layer.borderWidth = 0.5
            questionCell.questionsCollectionViewCell()
            questionCell.displayClass = currentClass
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

}
