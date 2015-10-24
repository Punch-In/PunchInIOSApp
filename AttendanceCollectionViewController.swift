//
//  AttendanceCollectionViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/21/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class AttendanceCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var attendanceCollectionView: UICollectionView!
    var course:Courses!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
        attendanceCollectionView.delegate = self
        attendanceCollectionView.dataSource = self
        attendanceCollectionView.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: Setup UI Methods
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width/3-30, self.view.bounds.height/5)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        attendanceCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    // MARK: Collection View Delegate Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let studentArray = course.studentArray
        return (studentArray?.count)!;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = attendanceCollectionView.dequeueReusableCellWithReuseIdentifier("AttendanceCollectionViewCell", forIndexPath: indexPath) as! AttendanceCollectionViewCell
        let localcourse:Courses = course
        let studentArray :[Student] = localcourse.studentArray!
        let student:Student = studentArray[indexPath.row]
        cell.studentName.text = student.studentName
        cell.studentImage.image = student.studentImage
        cell.totalAttendance.text = student.attendanceOfStudent
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.backgroundColor = ThemeManager.theme().secondaryPrimaryColor()
        cell.studentName?.textColor = UIColor.whiteColor()
        cell.totalAttendance.textColor = UIColor.whiteColor()
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shadowOffset = CGSizeZero
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "AttendanceSegue"){
            let vc:DetailAttendanceViewController = segue.destinationViewController as! DetailAttendanceViewController
            let cell = sender as! UICollectionViewCell
            let indexPath  = attendanceCollectionView.indexPathForCell(cell) as NSIndexPath!
            let localcourse:Courses = course
            let studentArray :[Student] = localcourse.studentArray!
            let student:Student = studentArray[indexPath.row]
            vc.student = student
            vc.course = localcourse
        }
    }
}
