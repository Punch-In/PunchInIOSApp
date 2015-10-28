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
    
    private static let noUserProvidedText = "Please provide an email address"
    private static let noPasswordProvidedText = "Please provide a password"
    private static let badUserText = "Email and/or Password is not valid"
    private static let notInstructorText = " is not an Instructor"
    private static let notStudentText = " is not a Student"

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    @IBOutlet weak var invalidEntryLabel: UILabel!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ParseDB.BadLoginNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ParseDB.BadTypeNotificationName, object:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        invalidEntryLabel.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "badUser", name:ParseDB.BadLoginNotificationName, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "badType", name:ParseDB.BadTypeNotificationName, object:nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func validateInput() -> Bool {
        return !nameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
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
        let errorText = typeSelector.selectedSegmentIndex==0 ? LoginViewController.notStudentText : LoginViewController.notInstructorText
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
            type: LoginViewController.userTypes[typeSelector.selectedSegmentIndex])
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
