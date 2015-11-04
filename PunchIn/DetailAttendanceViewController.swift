//
//  DetailAttendanceViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailAttendanceViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    weak var course:Course!
    weak var student:Student!
    private var classes:[Class]! {
        didSet {
            attendanceCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var dailyAttendanceView: UIView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var totalAttendance: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var attendanceCollectionView: UICollectionView!
    
    // MARK: refresh hacks
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceCollectionView.delegate = self
        attendanceCollectionView.dataSource = self
        studentName.text = student.studentName
        className.text = course.courseName
    
        // get student image
        student.getImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.studentImage.image = image
                }
            }else{
                print("error getting image for student \(self.student.studentName)")
            }
        }
        
        setCollectionViewLayout()
        
        attendanceCollectionView.backgroundColor = UIColor.whiteColor()
        dailyAttendanceView.backgroundColor = ThemeManager.theme().primaryBlueColor()
    
        studentName.textColor = UIColor.whiteColor()
        className.textColor = UIColor.whiteColor()
        totalAttendance.textColor = UIColor.whiteColor()
        
        // calculate attendance percentage
        let numClassesAttended = course.classes!.filter({$0.didStudentAttend(self.student)}).count
        let numClassesStarted = course.classes!.filter({$0.isStarted}).count
        let pctAttendance = (Double(numClassesAttended) / Double(numClassesStarted))*100.0
        totalAttendance.text = String(format:"%.0f%% Attendance", pctAttendance)
        
        // hack
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        attendanceCollectionView.alwaysBounceVertical = true
        attendanceCollectionView.addSubview(refreshControl)

        classes = course.classes!
    }

    func refreshData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Updating attendance details..."
        
        course.refreshAttendanceForCourse(student) { (classes, error) -> Void in
            if error ==  nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.classes = classes!
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
    }
    
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/10)
        flowLayout.minimumInteritemSpacing = 5
        attendanceCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return classes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = attendanceCollectionView.dequeueReusableCellWithReuseIdentifier("DailyAttendanceCollectionViewCell", forIndexPath: indexPath) as! DailyAttendanceCollectionViewCell
        
        let theClass = classes[indexPath.row]
        cell.layer.borderColor = ThemeManager.theme().primaryBlueColor().CGColor
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderWidth = 0.25
        cell.setupUI()
        cell.student = student
        cell.displayClass = theClass
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CourseViewController") as! CourseViewController
        vc.startIndex = indexPath.row
        vc.course = course
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
