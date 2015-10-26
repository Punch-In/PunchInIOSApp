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
    

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
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

    @IBAction func accountLogin(sender: AnyObject) {
        guard validateInput() else {
            return  // TODO: alert
        }
        
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
