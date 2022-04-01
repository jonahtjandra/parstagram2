//
//  FeedViewController.swift
//  parstagram
//
//  Created by Jonah Tjandra on 3/25/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var feed: UITableView!
    
    let commentBar = MessageInputBar()
    
    var showsCommentBar = false;
    
    var posts =  [PFObject]()
    
    var currPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feed.delegate = self
        feed.dataSource = self
        feed.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        commentBar.inputTextView.placeholder = "Add a comment"
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false;
        becomeFirstResponder()
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = currPost
        comment["author"] = PFUser.current()!
        currPost.add(comment, forKey: "comments")
        currPost.saveInBackground { success, error in
          if success {
             print("Comment successfully made")
          } else {
              print("Error making comment: \(error)")
          }
        }
        feed.reloadData()
        //Clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar;
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author","comments","comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { posts, error in
            if (error != nil) {
                print("ERROR: \(error!)")
            } else {
                self.posts = posts!
                self.feed.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["author"] as! PFUser
            cell.username.text = user.username
            cell.caption.text = post["caption"] as? String
            
            let imageFile = post["post"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.photo.af.setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            cell.comment.text = comments[indexPath.row - 1]["text"] as? String
            cell.usernameComment.text = (comments[indexPath.row - 1]["author"] as! PFUser).username
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comment = PFObject(className: "Comments")
        currPost = post
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == comments.count + 1 {
            print("HUH")
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
    }

    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.view.window?.rootViewController = viewController
    }
}
