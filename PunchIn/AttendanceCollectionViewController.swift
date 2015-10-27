//
//  AttendanceCollectionViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/21/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class AttendanceCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    private static let AttendanceCollectionViewCellName = "AttendanceCollectionViewCell"
    
    @IBOutlet weak var attendanceCollectionView: UICollectionView!
    var theClass: Class!
    private var studentArray: [Student]! {
        didSet {
            attendanceCollectionView.reloadData()
        }
    }
    
    // MARK: refresh hacks
    var refreshControl : UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
        attendanceCollectionView.delegate = self
        attendanceCollectionView.dataSource = self
        attendanceCollectionView.backgroundColor = UIColor.whiteColor()
        
        // hack
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        
        attendanceCollectionView.alwaysBounceVertical = true
        attendanceCollectionView.addSubview(refreshControl)
        
        // data
        studentArray = theClass.attendance!
    }
    
    // MARK: data fetch
    func fetchData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Updating attendance..."
        
        theClass.refreshAttendance { (attendance, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.studentArray = attendance!
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                print("error updating attendance! \(error)")
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
        
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
        return studentArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = attendanceCollectionView.dequeueReusableCellWithReuseIdentifier(AttendanceCollectionViewController.AttendanceCollectionViewCellName, forIndexPath: indexPath) as! AttendanceCollectionViewCell
        cell.student = studentArray[indexPath.row]        
        return cell
    }
    
    // MARK: - Navigation
    private static let detailAttendanceSegueName = "DetailAttendanceSegue"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == AttendanceCollectionViewController.detailAttendanceSegueName ){
            let vc:DetailAttendanceViewController = segue.destinationViewController as! DetailAttendanceViewController
            let cell = sender as! UICollectionViewCell
            let indexPath  = attendanceCollectionView.indexPathForCell(cell) as NSIndexPath!
            vc.course = theClass.parentCourse
            vc.student = studentArray[indexPath.row]
        }
    }
}
