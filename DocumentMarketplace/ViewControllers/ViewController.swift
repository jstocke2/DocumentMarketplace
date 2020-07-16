//
//  ViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 6/7/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }

    func setUpElements(){
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
    }

}

