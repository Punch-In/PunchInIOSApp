//
//  InstructorDraggableCollectionViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD


class InstructorDraggableCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var course:Course!
    var classIndex:Int!
    var indexNumber:Int!
    private var currentClass: Class!
    let refreshControl = UIRefreshControl()
    @IBOutlet var instructorDraggableCollectionView: UICollectionView!
    
    @IBOutlet weak var mapButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValues()
        setCollectionViewLayout()

        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: "setUpValues", forControlEvents: .ValueChanged)
        instructorDraggableCollectionView.addSubview(refreshControl)
        instructorDraggableCollectionView.alwaysBounceVertical = true
        instructorDraggableCollectionView.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setUpValues(){
        // show current class
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Refreshing class info..."
        currentClass = course.classes![classIndex]
        currentClass.refreshDetails { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.refreshControl.endRefreshing()
                    self.instructorDraggableCollectionView.reloadData()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/6)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        instructorDraggableCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        if(indexPath.row == 0){
            return CGSizeMake(self.view.bounds.size.width,60)
        }
        if(indexPath.row == 1){
            if(self.currentClass.classDescription.characters.count < 200){
                CGSizeMake(self.view.bounds.size.width,100)
            }else if(self.currentClass.classDescription.characters.count > 200 && self.currentClass.classDescription.characters.count < 250){
                return CGSizeMake(self.view.bounds.size.width,130)
            }else if(self.currentClass.classDescription.characters.count > 250 && self.currentClass.classDescription.characters.count < 300){
                return CGSizeMake(self.view.bounds.size.width,160)
            }else if(self.currentClass.classDescription.characters.count > 300 && self.currentClass.classDescription.characters.count < 350){
                return CGSizeMake(self.view.bounds.size.width,190)
            }
        }
        if(indexPath.row == 2){
            return CGSizeMake(self.view.bounds.width, 100)

        }
        if(indexPath.row == 3){
            return CGSizeMake(self.view.bounds.width,100)
        }
        return CGSizeMake(self.view.bounds.width, self.view.bounds.height/5)
    }
    
    
    func classStarted(){
        refreshControl.endRefreshing()
    }
    
    func classEnded(){
        refreshControl.endRefreshing()
    }
    
    // MARK: Collection View Controller Methods :
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if(indexPath.row == 2){
            let storyBoardName = "Main"
            let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
            let vc = storyBoard.instantiateViewControllerWithIdentifier("AttendanceCollectionViewController") as! AttendanceCollectionViewController
            vc.theClass = currentClass
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if(indexPath.row == 3){
            let storyBoardName = "Main"
            let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
            let vc = storyBoard.instantiateViewControllerWithIdentifier("QuestionsListViewController") as! QuestionsListViewController
            vc.theClass = currentClass
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    /*
    self.attendanceCount.text = "\(self.currentClass.attendance!.count)"
    self.questionCount.text = "\(self.currentClass.questions!.count)"
    self.unansweredQuestionCount.text = "\(self.currentClass.questions!.filter({!$0.isAnswered}).count)"
    */
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        if indexPath.row == 0{
            let checkIncell:InstructorCourseStartCellCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorCourseCheckInCell", forIndexPath: indexPath) as! InstructorCourseStartCellCollectionViewCell
            checkIncell.backgroundColor = ThemeManager.theme().primaryYellowColor()
            checkIncell.setupUI()
            checkIncell.displayClass = currentClass
            return checkIncell;
        }
        
        if indexPath.row == 1 {
          let  cell:InstructorCourseNameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorCourseNameCell", forIndexPath: indexPath) as! InstructorCourseNameCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.setupUI()
            cell.displayClass = currentClass
            return cell
        }
    
        if indexPath.row == 2{
            let attendanceCell:InstructorAttendanceCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorAttendanceCell",forIndexPath:indexPath) as! InstructorAttendanceCollectionViewCell
            
            attendanceCell.backgroundColor = UIColor.whiteColor()
            attendanceCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            attendanceCell.layer.borderWidth = 0.5
            attendanceCell.setAttendanceCollectionViewCell()
            attendanceCell.displayClass = currentClass
            return attendanceCell
        }
        
        let questionCell:InstructorQuestionCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorQuestionsCell",forIndexPath:indexPath) as! InstructorQuestionCollectionViewCell
            questionCell.backgroundColor = UIColor.whiteColor()
            questionCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            questionCell.layer.borderWidth = 0.5
            questionCell.questionsCollectionViewCell()
            questionCell.displayClass = currentClass
            return questionCell
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
