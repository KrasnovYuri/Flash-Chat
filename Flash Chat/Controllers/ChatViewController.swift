//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Юрий on 18.12.2023.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
//        Message(sender: "1@2.com", body: "Hey!"),
//        Message(sender: "a@b.com", body: "Hello!"),
//        Message(sender: "1@2.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()
    }
    
    func loadMessage() {
        messages = []
        
        db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
            if let error {
                print(error)
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else { return }
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let sender = data[K.FStore.senderField] as? String else { return }
                    guard let messageBody = data[K.FStore.bodyField] as? String else { return }
                    let newMessage = Message(sender: sender, body: messageBody)
                    self.messages.append(newMessage)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextField.text else { return }
        guard let messageSender = Auth.auth().currentUser?.email else { return }
        db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody]) { error in
            if let error {
                print(error)
            } else {
                print("Successfully saved data")
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        return cell
    }
}

