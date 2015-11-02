//
//  CoursesListViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MBProgressHUD

class CoursesListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    static let storyboardName = "CoursesListViewController"
    let CoursesListCellIdentifier  = "CoursesListCell"
    //var userType:String!
    
    var courseArray:[Course] = [] {
        didSet {
            coursesCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    
    // MARK: View Controller Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        setUpUI()
        setCollectionViewLayout()
        fetchData()
    }

    func fetchData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Getting courses..."
        
        Course.courses({
            (courses, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.courseArray = courses!
//                    print(self.courseArray[0].classes?[0])
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                })
            }else{
                print("error getting courses! \(error)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        })
    }

    // MARK: Setup Methods
    func setUpDelegates(){
        coursesCollectionView.delegate = self
        coursesCollectionView.dataSource = self
    }
    
    func setUpUI(){
        coursesCollectionView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = ThemeManager.theme().primaryDarkBlueColor()
        self.navigationItem.title = "Courses"
        self.navigationController?.navigationItem.title = "Courses"
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary.init(dictionary:
            [NSForegroundColorAttributeName:UIColor.whiteColor()]) as? [String : AnyObject]
        
        // logout button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target:self, action: "tappedLogout")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func tappedLogout() {
        ParseDB.logout()
    }
    
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width-20, self.view.bounds.height/5)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        coursesCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    
    // MARK:Collection View Delegate Methods.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return courseArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CoursesListCellIdentifier, forIndexPath: indexPath) as! CoursesListsCollectionViewCell
        
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shadowOffset = CGSizeZero
        cell.layer.cornerRadius = 10
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = ThemeManager.theme().primaryGreyColor()
        }else{
            cell.backgroundColor = ThemeManager.theme().primaryBlueColor()
        }
                
        cell.setupUI()
        cell.displayCourse = courseArray[indexPath.row]
        return cell;
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CoursesSegue"){
            let courseViewController:CourseViewController = segue.destinationViewController as! CourseViewController
            let cell = sender as! UICollectionViewCell
            let indexPath  = coursesCollectionView!.indexPathForCell(cell) as NSIndexPath!
            let selectedCourse:Course = courseArray[indexPath.row] as Course
           // courseViewController.userType = userType
            courseViewController.course = selectedCourse
        }
    }
    
    @IBAction func showMapViewTapped(sender: AnyObject) {
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil);
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ClassMapViewController") as! ClassMapViewController
        vc.currentClass = courseArray[0].classes![0]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
