//
//  SignUpVC.swift
//  Pictionis
//
//  Created by David LIN on 29/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import UIKit
import Firebase


class SignUpVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var labelErr: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func viewWillAppear() {
        email.text = ""
        password.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: email.text!, password: self.password.text!) { (authResult, error) in
            guard let user = authResult?.user else {
                self.labelErr.text = "Erreur lors de l'inscription"
                return
            }
            
            self.labelErr.text = ""
            self.email.text = ""
            self.password.text = ""
            self.dismiss(animated: true, completion: nil);
        }
    }
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }
}
