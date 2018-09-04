//
//  ViewController.swift
//  Pictionis
//
//  Created by David LIN on 27/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    // inputs
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // Création de constantes pour les identifiants des différents segues
    // Ça nous permet de nous déplacer entre les views
    private let SIGNUP_SEGUE = "SignUpSegue" // pour aller sur la vue d'inscription
    private let HOME_SEGUE = "HomeSegue" // pour aller à l'accueil après la connexion
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isLoggedIn()) {
            self.performSegue(withIdentifier: self.HOME_SEGUE, sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true;
        }
        
        return false;
    }
    
    // bouton connexion
    @IBAction func signIn(_ sender: UIButton) {
        // connexion
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            // ...
            if(user != nil) {
                self.email.text = ""
                self.password.text = ""
                self.performSegue(withIdentifier: self.HOME_SEGUE, sender: nil) // on appelle la segue home après que la connexion ce soit bien passé
            } else {
                // crée une alerte pour l'utilisateur
                let alert = UIAlertController(title: "Erreur", message: "Echec de la connexion.", preferredStyle: UIAlertControllerStyle.alert)
                
                // ajoute une action (bouton)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // Affiche l'alerte
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // bouton pas de compte ?
    @IBAction func signUpView(_ sender: Any) {
        self.email.text = ""
        self.password.text = ""
        
        // on appelle la segue signup pour aller sur la page inscription
        performSegue(withIdentifier: SIGNUP_SEGUE, sender: nil)
    }
}

