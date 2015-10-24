//
//  CoursesListViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class CoursesListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let CoursesListCellIdentifier  = "CoursesListCell"
    let courseArray:[Courses] = Courses.getAllCourses()
    
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    
    // MARK: View Controller Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        setUpUI()
        setCollectionViewLayout()
    }
    
    // MARK: Setup Methods
    func setUpDelegates(){
        coursesCollectionView.delegate = self
        coursesCollectionView.dataSource = self
    }
    
    func setUpUI(){
        coursesCollectionView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = ThemeManager.theme().primaryColor()
        self.navigationItem.title = "Courses"
        self.navigationController?.navigationItem.title = "Courses"
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary.init(dictionary:
            [NSForegroundColorAttributeName:UIColor.whiteColor()]) as? [String : AnyObject]
        
    }
    
    func setCollectionViewLayout(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSizeMake(self.view.bounds.width/2-20, self.view.bounds.height/5)
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
        cell.setCoursesListCollectionViewCell(courseArray[indexPath.row])
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.backgroundColor = ThemeManager.theme().secondaryPrimaryColor()
        cell.courseNameLabel?.textColor = UIColor.whiteColor()
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shadowOffset = CGSizeZero
        return cell;
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CoursesSegue"){
            let courseViewController:CourseViewController = segue.destinationViewController as! CourseViewController
            let cell = sender as! UICollectionViewCell
            let indexPath  = coursesCollectionView!.indexPathForCell(cell) as NSIndexPath!
            let selectedCourse:Courses = courseArray[indexPath.row] as Courses
            courseViewController.course = selectedCourse
        }
    }

}
