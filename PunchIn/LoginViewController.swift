//
//  LoginViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    static let loginSegueName = "loginSegue"
    
    static let userTypes = [ "Student", "Instructor" ]
    
    private let initialEmailAddress = "email@address.com"
    private let initialPassword = "password"
    
    private static let noUserProvidedText = "Please provide an email address"
    private static let noPasswordProvidedText = "Please provide a password"
    private static let badUserText = "Email and/or Password is not valid"
    private static let notInstructorText = " is not an Instructor"
    private static let notStudentText = " is not a Student"

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidEntryLabel: UILabel!
    @IBOutlet var studentIndicatorTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var studentIndicatorImage: UIImageView!
    
    private var isStudent: Bool = false
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ParseDB.BadLoginNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ParseDB.BadTypeNotificationName, object:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizer()
        
        isStudent = false
        studentIndicatorImage.image = UIImage(named: "unselected_button_login.png")
     
        // Do any additional setup after loading the view.
        invalidEntryLabel.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "badUser", name:ParseDB.BadLoginNotificationName, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "badType", name:ParseDB.BadTypeNotificationName, object:nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    private func setupUI() {
        // set color schemes, etc
        
        // set background color
        self.view.backgroundColor = ThemeManager.theme().primaryDarkBlueColor()
        
        // set background color for email address & password field
        nameTextField.backgroundColor = ThemeManager.theme().primaryBlueColor()
        nameTextField.textColor = UIColor.whiteColor()
        nameTextField.placeholder = initialEmailAddress
        passwordTextField.backgroundColor = ThemeManager.theme().primaryBlueColor()
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.placeholder = initialPassword
        
        // set login
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 1.0
        loginButton.tintColor = UIColor.whiteColor()
        
        // set color for invalid entry
        invalidEntryLabel.textColor = ThemeManager.theme().primaryYellowColor()
        
    }
    
    private func setupGestureRecognizer() {
        studentIndicatorTapGesture.addTarget(self, action: "didTapStudentIndicator")
    }
    
    func didTapStudentIndicator() {
        if isStudent {
            // change to not student
            isStudent = false
            studentIndicatorImage.image = UIImage(named: "unselected_button_login.png")
        }else{
            // change to student
            isStudent = true
            studentIndicatorImage.image = UIImage(named: "selected_button_login.png")
        }
    }
    
    
    func validateInput() -> Bool {
        var goodInput: Bool = true
        goodInput = goodInput && !nameTextField.text!.isEmpty
        goodInput = goodInput && !passwordTextField.text!.isEmpty
        goodInput = goodInput && !(nameTextField.text==initialEmailAddress)
        goodInput = goodInput && !(passwordTextField.text==initialPassword)
        
        return goodInput
    }
    
    private func updateInvalidDataText(status: String) {
        self.invalidEntryLabel.alpha = 0
        self.invalidEntryLabel.hidden = false
        self.invalidEntryLabel.text = status
        UIView.animateWithDuration(0.5) { () -> Void in
            self.invalidEntryLabel.alpha = 1
        }
    }
        
    func badUser() {
        updateInvalidDataText(LoginViewController.badUserText)
    }
    
    func badType() {
        let errorText = isStudent ? LoginViewController.notStudentText : LoginViewController.notInstructorText
        updateInvalidDataText(self.nameTextField.text! + errorText)
    }

    @IBAction func accountLogin(sender: AnyObject) {
        guard !nameTextField.text!.isEmpty else {
            updateInvalidDataText(LoginViewController.noUserProvidedText)
            return
        }
        
        guard !passwordTextField.text!.isEmpty else {
            updateInvalidDataText(LoginViewController.noPasswordProvidedText)
            return
        }
        
        self.invalidEntryLabel.hidden = true
        ParseDB.login(nameTextField!.text!, password: passwordTextField!.text!,
            type: isStudent ? LoginViewController.userTypes[0] : LoginViewController.userTypes[1])
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
    }

}
