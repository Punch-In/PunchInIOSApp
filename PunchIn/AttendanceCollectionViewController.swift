//
//  AttendanceCollectionViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/21/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class AttendanceCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    private enum SwitcherSegmentIndex : Int {
        case Present = 0
        case Absent = 1
    }
    
    private static let AttendanceCollectionViewCellName = "AttendanceCollectionViewCell"
    
    @IBOutlet weak var presentOrAbsentSwitcher: UISegmentedControl!
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
        
        self.navigationController?.navigationBar.barTintColor = ThemeManager.theme().primaryDarkBlueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        setupUI()
        setCollectionViewLayout()
        
        // data
        studentArray = theClass.attendance!
    }
    
    func setupUI() {
        attendanceCollectionView.delegate = self
        attendanceCollectionView.dataSource = self
        attendanceCollectionView.backgroundColor = UIColor.whiteColor()
        
        // hack
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        attendanceCollectionView.alwaysBounceVertical = true
        attendanceCollectionView.addSubview(refreshControl)
        
        // set initial segmented index
        presentOrAbsentSwitcher.selectedSegmentIndex = SwitcherSegmentIndex.Present.rawValue
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
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width/3-16, 100)
        flowLayout.minimumInteritemSpacing = 5
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
        cell.setupUI()
        cell.student = studentArray[indexPath.row]
        
        return cell
    }
    
    // MARK: present or absent switcher action
    @IBAction func didTapPresentOrAbsent(sender: AnyObject) {
        let selected = SwitcherSegmentIndex(rawValue: self.presentOrAbsentSwitcher.selectedSegmentIndex)!
        
        switch selected {
        case .Absent:
            self.studentArray = theClass.absentStudents()
        case .Present:
            self.studentArray = theClass.attendance!
        }
        
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
