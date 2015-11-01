//
//  QuestionsListViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class QuestionsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    private static let cellIdentifier = "QuestionTableViewCell"
    
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var newQuestionText: UITextView!
    
    // MARK: refresh hacks
    var refreshControl : UIRefreshControl!
    
    var theClass: Class!
    private var questions: [Question] = [] {
        didSet {
            // order by newest first
            questions.sortInPlace{ $0.date.compare($1.date) == .OrderedDescending }
            questionTableView.reloadData()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTableView.dataSource = self
        questionTableView.delegate = self
        newQuestionText.delegate = self
        
        // hack
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = questionTableView
        dummyTableVC.refreshControl = refreshControl
        
        setupUI()
        initializeNewQuestionText()

        // show questions (if exist)
        questions = theClass.questions!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        // need to do anything?
    }
    
    func initializeNewQuestionText() {
        newQuestionText.textColor = UIColor.grayColor()
        newQuestionText.text = "What's your question?"
    }

    
    func fetchData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Fetching new questions..."

        theClass.refreshQuestions { (questions, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.questions = questions!
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }else{
                print("error refreshing questions! \(error)")
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QuestionsListViewController.cellIdentifier, forIndexPath: indexPath) as! QuestionTableViewCell
        
        cell.question = questions[indexPath.row]
        
        return cell
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        newQuestionText.textColor = UIColor.blackColor()
        newQuestionText.text = ""
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        newQuestionText.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        // create new question
        let question = Question.createQuestion(ParseDB.currentPerson!.getName(), text:newQuestionText.text, date:NSDate(), inClass: theClass)
        theClass.addQuestion(question)
        questions.append(question)
        initializeNewQuestionText()
        newQuestionText.resignFirstResponder()
    }
    
    // MARK: keyboard handling
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    func keyboardWillShow(notification: NSNotification!) {
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offsetSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationDuration = durationValue.doubleValue
        
        if keyboardSize.height == offsetSize.height {
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                //self.bottomConstraint.constant = keyboardSize.height + 8
            })
        }else{
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                //self.bottomConstraint.constant = offsetSize.height + 8
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationDuration = durationValue.doubleValue
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            //self.bottomConstraint.constant = 8
        })
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
