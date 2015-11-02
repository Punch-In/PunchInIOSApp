//
//  InstructorDraggableCollectionViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 11/1/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit


class InstructorDraggableCollectionViewController: UICollectionViewController {

    var course:Course!
    var classIndex:Int!
    var indexNumber:Int!
    private var currentClass: Class!
    let refreshControl = UIRefreshControl()
    private var classDescription:String!
    @IBOutlet var instructorDraggableCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classDescription = " ";
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
        currentClass = course.classes![classIndex]
        currentClass.refreshDetails { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.classDescription = self.currentClass.classDescription
                                      // set "class start" view based on class status
                    
                    if self.currentClass.isFinished {
                    self.classDescription = Class.classFinishedText
                        
                    }else if self.currentClass.isStarted {
                    self.classDescription = Class.classStartedText
                        
                    }else {
                        self.classDescription = Class.classStartedText
                    }
                }
            }
        }
        instructorDraggableCollectionView.reloadData()
        refreshControl.endRefreshing()
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
            checkIncell.setUpCourseStartCell(currentClass)
            checkIncell.backgroundColor = ThemeManager.theme().primaryYellowColor()
            return checkIncell;
        }
        
        if indexPath.row == 1 {
          let  cell:InstructorCourseNameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorCourseNameCell", forIndexPath: indexPath) as! InstructorCourseNameCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            cell.setUpCourseName()
            cell.setUpClassNameAndClassDescription(currentClass.name, aclassDescription: classDescription)
            cell.layer.borderWidth = 0.5
            return cell
        }
    
        if indexPath.row == 2{
            let questionCell:InstructorAttendanceCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorAttendanceCell",forIndexPath:indexPath) as! InstructorAttendanceCollectionViewCell
            
            questionCell.backgroundColor = UIColor.whiteColor()
            questionCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            questionCell.layer.borderWidth = 0.5
            questionCell.setAttendanceCollectionViewCell()
            return questionCell
        }
        
        let questionCell:InstructorQuestionCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorQuestionsCell",forIndexPath:indexPath) as! InstructorQuestionCollectionViewCell
            questionCell.backgroundColor = UIColor.whiteColor()
            questionCell.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
            questionCell.layer.borderWidth = 0.5
            questionCell.questionsCollectionViewCell()
            let questionsCount = "\(currentClass.questions!.count)";
        questionCell.setQuestionValues(questionsCount)
        return questionCell
    
    }
}