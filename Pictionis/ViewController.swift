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

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var labelErr: UILabel!
    
    private let SIGNUP_SEGUE = "SignUpSegue"
    private let HOME_SEGUE = "HomeSegue"
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewWillAppear() {
    }
    
    func viewWillDisappear() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            // ...
            if(user != nil) {
                self.labelErr.text = ""
                self.email.text = ""
                self.password.text = ""
                self.performSegue(withIdentifier: self.HOME_SEGUE, sender: nil)
            } else {
                self.labelErr.text = "Echec de la connexion"
            }
        }
    }
    
    @IBAction func signUpView(_ sender: Any) {
        performSegue(withIdentifier: SIGNUP_SEGUE, sender: nil)
    }
}

