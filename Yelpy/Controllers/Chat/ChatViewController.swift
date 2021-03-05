//
//  ChatViewController.swift
//  Yelpy
//
//  Created by Memo on 7/1/20.
//  Copyright © 2020 memo. All rights reserved.
//

/*------ Comment ------*/

import UIKit
import Parse

class ChatViewController: UIViewController {

    
    /*------ Outlets + Variables ------*/
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // ––––– LAB 5 TODO: CREATE ARRAY FOR MESSAGES
    var messages: [PFObject] = []
    
    // ––––– LAB 5 TODO: CREATE CHAT MESSAGE OBJECT
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        
        // Lab 5 TODO: Reload messages every second (interval of 1 second)
        onTimer()
        tableView.reloadData()
    }
    
        @objc func onTimer() {
            retrieveChatMessages()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        }
    
    
    
    
    /*------  Message Functionality ------*/
    
    // ––––– ADD FUNCTIONALITY TO retrieveChatMessages()
    @objc func retrieveChatMessages() {
        let query = PFQuery(className: "iOS_Spring2021")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("user")
        query.findObjectsInBackground{(messages, error) in
            if let messages = messages {
                self.messages = messages
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    //  ––––– LAB 5 TODO: SEND MESSAGE TO SERVER AFTER onSend IS CLICKED
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "iOS_Spring2021")
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage["user"] = PFUser.current() ?? ""
        chatMessage.saveInBackground{(success, error) in
            if success {
                print("The message was saved")
                self.messageTextField.text = ""
            } else if let error = error {
                print("problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    //  ––––– LAB 5 TODO: Logout
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground()
        NotificationCenter.default.post(name: NSNotification.Name("logOut"), object: nil)
    }
    
    
    /*------ Dismiss Keyboard and Logout ------*/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}


/*------ TableView Extension Functions ------*/

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // NOTE: Don't worry about the error, please follow the lab!
        return messages.count
    }
    
    
    
    // BONUS: IMPLEMENT CELL DIDSET
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        // NOTE: Please follow the lab before asking for help :)
        let message = messages[indexPath.row]
        cell.messageLabel.text = message["text"] as? String
        
        // set the username
        if let user = message["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "?"
        }
        
        // BONUS: ADD avatarImage TO CELL STORYBOARD AND CONNECT TO ChatCell
//        let baseURL = "https://api.adorable.io/avatars/"
//        let imageSize = 20
//        let avatarURL = URL(string: baseURL+"\(imageSize)/\(identifier).png")
//        cell.avatarImage.af_setImage(withURL: avatarURL!)
//        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.height / 2
//        cell.avatarImage.clipsToBounds = true
    

        return cell
    }
    
    
}



