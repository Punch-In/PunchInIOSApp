//
//  QuestionsListViewController.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class QuestionsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    private static let cellIdentifier = "QuestionTableViewCell"
    
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var newQuestionText: UITextView!
    
    var theClass: Class!
    private var questions: [Question] = [] {
        didSet {
            questionTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTableView.dataSource = self
        questionTableView.delegate = self
        newQuestionText.delegate = self
        
        initializeNewQuestionText()

        // show questions (if exist)
        questions = theClass.questions!
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
