//
//  HomeVC.swift
//  Pictionis
//
//  Created by David LIN on 29/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // table view pour l'affichage des msg
    @IBOutlet weak var messageTableView: UITableView!

    // tous les msgs
    private var messages = [Message]()
    
    // input et bouton pour le chat
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // canvasView avec tous les éléments de la class canvasView
    @IBOutlet weak var canvasView: CanvasView!
    
    // type de la variable
    var db:Firestore!
    var connectionDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil { // Vérifie s'il y a un utilisateur de connecté
            dismiss(animated: true, completion: nil) // retourne à la vue précédente
        }
        
        //initialise la reference à la db
        db = Firestore.firestore()
        connectionDate = Date()
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        getMessages()
        
        listenerOnMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserEmail() -> String {
        return Auth.auth().currentUser!.email!;
    }
    
    func getUserID() -> String {
        return Auth.auth().currentUser!.uid;
    }
    
    // TABLE VIEW

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        // create a table cell
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        // customize the cell
        cell.textLabel?.text = "\(self.messages[indexPath.row].username!): \(self.messages[indexPath.row].text!)"
        
        // return the cell
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // bouton déconnecter
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser != nil { // Vérifie s'il y a un utilisateur de connecté
            do {
                try Auth.auth().signOut(); // déconnecte l'utilisateur
                dismiss(animated: true, completion: nil) // retourne à la vue précédente
            } catch {
                
            }
        }
    }
    
    // function clear du canvas
    @IBAction func clearCanvas(_ sender: UIBarButtonItem) {
        canvasView.clearCanvas()
    }
    
    // envoie de msg
    @IBAction func sendMessage(_ sender: UIButton) {
        let newMessage = Message(username: getUserEmail(), text: self.messageTextField.text!, timeStamp: Date())
        var ref:DocumentReference? = nil
        ref = self.db.collection("messages").addDocument(data: newMessage.dictionary) {
            error in
            
            if let error = error {
                print("Error adding messages: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // db get collections

//        getMessages()
        self.messageTextField.text = ""
    }
    
    func getMessages() {
        self.db.collection("messages").whereField("timeStamp", isGreaterThanOrEqualTo: connectionDate).order(by: "timeStamp").getDocuments() {
            querySnapshot, error in
            
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.messages = querySnapshot!.documents.flatMap({Message(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()
                }
            }
        }
//        ref.observeSingleEvent(of: DataEventType.value) {
//            (snapshot) in
//            var messages = [Message]()
//            if let myMessages = snapshot.value as? NSDictionary {
//                for (_, value) in myMessages {
//                    if let messageData = value as? NSDictionary {
//                        let newMessage = Message(userId: (messageData["userId"] as? String)!, text: (messageData["text"] as? String)!)
//                        messages.append(newMessage)
//                    }
//                }
//            }
//            self.messages = messages
//            self.messageTableView.reloadData()
//        }
    }
    
    func listenerOnMessages() {
        db.collection("messages").whereField("timeStamp", isGreaterThanOrEqualTo: connectionDate)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.messages = documents.flatMap({Message(dictionary: $0.data())})
                
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()
                }
        }
    }
}
