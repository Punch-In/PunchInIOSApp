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
        
        initializeNewQuestionText()

        // show questions (if exist)
        questions = theClass.questions!
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
    
    func initializeNewQuestionText() {
        newQuestionText.textColor = UIColor.grayColor()
        newQuestionText.text = "What's your question?"
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
        let question = Question.createQuestion(PFUser.currentUser()!.email!, text:newQuestionText.text, date:NSDate(), inClass: theClass)
        theClass.addQuestion(question)
        questions.append(question)
        initializeNewQuestionText()
        newQuestionText.resignFirstResponder()
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
