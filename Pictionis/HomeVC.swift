//
//  HomeVC.swift
//  Pictionis
//
//  Created by David LIN on 29/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    // canvasView avec tous les éléments de la class canvasView
    @IBOutlet weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil { // Vérifie s'il y a un utilisateur de connecté
            dismiss(animated: true, completion: nil) // retourne à la vue précédente
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserID() -> String {
        return Auth.auth().currentUser!.uid;
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
}
