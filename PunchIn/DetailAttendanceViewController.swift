//
//  DetailAttendanceViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class DetailAttendanceViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    var course:Course!
    var student:Student!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceCollectionView.delegate = self
        attendanceCollectionView.dataSource = self
        
//        course?.attendanceForCourse(student, completion: { (classes, isRegistered) -> Void in
//            if isRegistered {
//                self.classAttendance = classes
//            }else{
//                print("student \(self.student.studentName) not registered for course \(self.course.courseName)")
//                self.classAttendance = []
//            }
//        })
        
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
        attendanceCollectionView.backgroundColor = ThemeManager.theme().primaryColor()
       
        ThemeManager.theme().themeForContentView(dailyAttendanceView)
        ThemeManager.theme().themeForTitleLabels(studentName)
        ThemeManager.theme().themeForTitleLabels(className)
        ThemeManager.theme().themeForTitleLabels(totalAttendance)

        // calculate attendance percentage
        let numClassesAttended = course.classes!.filter({$0.didStudentAttend(self.student)}).count
        let pctAttendance = (Double(numClassesAttended) / Double(course.classes!.count))*100.0
        totalAttendance.text = String(format:"%.2f%% Attendance", pctAttendance)

        classes = course.classes!
    }

    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height/10)
        flowLayout.minimumInteritemSpacing = 10
        attendanceCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return classes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = attendanceCollectionView.dequeueReusableCellWithReuseIdentifier("DailyAttendanceCollectionViewCell", forIndexPath: indexPath) as! DailyAttendanceCollectionViewCell
        
        let theClass = classes[indexPath.row]
        cell.className.text = theClass.classDescription
        cell.classDate.text = DetailAttendanceViewController.classDateFormatter.stringFromDate(theClass.date)
        cell.classPresentOrAbsent.text = theClass.didStudentAttend(student) ? "Present" : "Absent"
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 10
        
        
        
        
        return cell
    }
    
    private static var classDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd y"
        return formatter
    }()

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
