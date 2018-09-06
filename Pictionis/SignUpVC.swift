//
//  SignUpVC.swift
//  Pictionis
//
//  Created by David LIN on 29/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    // Inputs
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var db:Firestore!
    var connectionDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //initialise la reference à la db
        db = Firestore.firestore()
        connectionDate = Date()

    }
    
    func viewWillAppear() {
        // on met les champs à vide pour ne pas avoir
        // les informations précédentes quand on revient sur la vue
        email.text = ""
        password.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // bouton Se connecter
    @IBAction func signUp(_ sender: UIButton) {
        // connexion
        Auth.auth().createUser(withEmail: email.text!, password: self.password.text!) { (authResult, error) in
            guard let user = authResult?.user else {
                
                // crée une alerte pour l'utilisateur
                let alert = UIAlertController(title: "Erreur", message: "Erreur lors de l'inscription.", preferredStyle: UIAlertControllerStyle.alert)
                
                // ajoute une action (bouton)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // Affiche l'alerte
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            self.db.collection("players").document(user.uid).setData(
                [
                    "email": user.email,
                    "online": false,
                    "state": ""
                ]
            )
                
            // on revient à la vue d'avant i.e la vue de connexion
            self.dismiss(animated: true, completion: nil);
        }
    }
    
    // bouton retour sur la barre de navigation
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil); // on revient à la vue de connexion
    }
}
