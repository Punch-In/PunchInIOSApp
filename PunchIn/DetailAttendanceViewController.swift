//
//  DetailAttendanceViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class DetailAttendanceViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    var course:Course?
    var student:Student?
    private var attendanceArray:[Attendance]!
    
    @IBOutlet weak var dailyAttendanceView: UIView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var totalAttendance: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var attendanceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceCollectionView.delegate = self
        attendanceCollectionView.dataSource = self
        attendanceArray = student?.attendances
        studentName.text = student?.studentName
        className.text = course?.courseName
        studentImage.image = student?.studentImage
        totalAttendance.text = student?.attendanceOfStudent
        setCollectionViewLayout()
        attendanceCollectionView.backgroundColor = ThemeManager.theme().primaryColor()
       
        ThemeManager.theme().themeForContentView(dailyAttendanceView)
        ThemeManager.theme().themeForTitleLabels(studentName)
        ThemeManager.theme().themeForTitleLabels(className)
        ThemeManager.theme().themeForTitleLabels(totalAttendance)
    }

    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/10)
        flowLayout.minimumInteritemSpacing = 10
        attendanceCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return (attendanceArray?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = attendanceCollectionView.dequeueReusableCellWithReuseIdentifier("DailyAttendanceCollectionViewCell", forIndexPath: indexPath) as! DailyAttendanceCollectionViewCell
        let attendance:Attendance = attendanceArray[indexPath.row]
        cell.className.text = attendance.theClassName
        cell.classDate.text = attendance.classDate
        cell.classPresentOrAbsent.text = attendance.classPresentOrAbsent
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 10
        
        return cell
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
