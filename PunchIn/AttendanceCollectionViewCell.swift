//
//  AttendanceCollectionViewCell.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class AttendanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var studentImage: UIImageView!
    @IBOutlet private weak var studentName: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var student: Student! {
        didSet {
            loadData()
            formatCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadData() {
        self.studentName.text = student.studentName
        // get student image
        student.getStudentImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.studentImage.image = image
                }
            }else{
                print("error getting image for student \(self.student.studentName)")
            }
        }
    }
  
    func formatCell() {
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 8.0)!, forKey: NSFontAttributeName)
        self.segmentControl.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.backgroundColor = ThemeManager.theme().secondaryPrimaryColor()
        self.studentName?.textColor = UIColor.whiteColor()
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeZero
        self.layer.cornerRadius = 10
    }
    
    
}
