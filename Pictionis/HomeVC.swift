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
    let INFO = "GameInfo"
    
    // table view pour l'affichage des msg
    @IBOutlet weak var messageTableView: UITableView!

    // tous les msgs
    private var messages = [Message]()
    
    // tous les joueurs en ligne
    private var players = [Player]()
    private var playersReady = 0
    
    private var currentPlayer:Player!
    
    private var roomMaster:Bool!
    
    // input et bouton pour le chat
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // canvasView avec tous les éléments de la class canvasView
    @IBOutlet weak var canvasView: CanvasView!
    
    @IBOutlet weak var startGameButton: UIBarButtonItem!
    
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

        updatePlayer(docData: ["online": true, "state": "waiting"], userId: getUserID())
        
        
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        getPlayer()
        listenerOnPlayer()
        
        getPlayers()
        listenerOnPlayers()
        
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
    
    func sendMsg(user:String, text:String) {
        let newMessage = Message(username: self.INFO, text: text, timeStamp: Date())
        self.db.collection("messages").addDocument(data: newMessage.dictionary)
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
                var userId = getUserID()
                
                try Auth.auth().signOut(); // déconnecte l'utilisateur
                
                updatePlayer(docData: ["online": false, "state": "offline"], userId: userId)
                dismiss(animated: true, completion: nil) // retourne à la vue précédente
            } catch {
                
            }
        }
    }
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        canvasView.clearCanvas()
    }
    
    // function clear du canvas
//    @IBAction func clearCanvas(_ sender: UIBarButtonItem) {
//
//    }
    
    @IBAction func startGame(_ sender: UIBarButtonItem) {
        //startgame
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
                if(self.messageTextField.text! == "pret" && self.currentPlayer.state == "waiting") {
                    self.updatePlayer(docData: ["state": "ready"], userId: self.getUserID())
                    self.sendMsg(user: self.INFO, text: "\(self.currentPlayer.email!) prêt")
                }
            }
            self.messageTextField.text = ""
        }
    }

    func updatePlayer(docData: [String: Any], userId: String) {
        db.collection("players").document(userId).updateData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("User successfully updated!")
            }
        }
    }
    
    // Fonctions pour recevoir des informations et avoir un listener sur différentes tables ou éléments
    
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
                    
                    var row = self.messages.count;
                    
                    if row > 0 {
                        let index = IndexPath(row: row - 1, section: 0)
                        self.messageTableView.scrollToRow(at: index, at: UITableViewScrollPosition.none, animated: true)
                    }
                }
        }
    }
    
    func getPlayer() {
        let docRef = db.collection("players").document(getUserID())
        
        docRef.getDocument{ (document, error) in
            self.currentPlayer = Player(dictionary: (document?.data()!)!)
            self.sendMsg(user: self.INFO, text: "\(self.currentPlayer.email!) connecté")
        }
    }
    
    func listenerOnPlayer() {
        db.collection("players").document(getUserID())
            .addSnapshotListener { DocumentSnapshot, error in
                guard let document = DocumentSnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.currentPlayer = Player(dictionary: document.data()!)
        }
    }
    
    func getPlayers() {
        self.db.collection("players").whereField("online", isEqualTo: true).getDocuments() {
            querySnapshot, error in
            
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.players = querySnapshot!.documents.flatMap({Player(dictionary: $0.data())})
                if self.players.count == 1 {
                    self.roomMaster = true
                } else {
                    self.roomMaster = false
                    
                }
                self.startGameButton.isEnabled = false
            }
        }
    }
    
    func listenerOnPlayers() {
        db.collection("players").whereField("online", isEqualTo: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                self.players = documents.flatMap({Player(dictionary: $0.data())})
                
                self.playersReady = 0
                self.players.forEach({ (player) in
                    if player.state == "ready" {
                        self.playersReady = self.playersReady + 1;
                    }
                })
                
                if(self.roomMaster == true) {
                    self.sendMsg(user: self.INFO, text: "Joueurs prêts \(self.playersReady)/\(self.players.count)")
                    
                    if(self.playersReady == self.players.count && self.players.count >= 2) {
                        self.startGameButton.isEnabled = true
                    }
                }
        }
    }
}
