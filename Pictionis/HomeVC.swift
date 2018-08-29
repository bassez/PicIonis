//
//  HomeVC.swift
//  Pictionis
//
//  Created by David LIN on 29/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
