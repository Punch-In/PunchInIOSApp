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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    func loadData() {
        self.studentName.text = student.studentName
        
        // get student image
        student.getImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.studentImage.alpha = 0
                    self.studentImage.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.studentImage.alpha = 1
                    })
                }
            }else{
                print("error getting image for student \(self.student.studentName)")
            }
        }
    }

    func setupUI() {
        self.studentName?.textColor = ThemeManager.theme().primaryBlueColor()
        self.studentImage.layer.borderWidth = 2.0
        self.studentImage.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
        self.studentImage.backgroundColor = UIColor.whiteColor()
        self.studentImage.layer.cornerRadius = self.studentImage.frame.size.width / 2
        self.studentImage.clipsToBounds = true
    }
    
    
}
