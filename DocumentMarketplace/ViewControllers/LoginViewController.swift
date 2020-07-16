//
//  LoginViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 6/7/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        ErrorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(LoginButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func LoginButtonTapped(_ sender: Any) {
        // validate text fields
        
        // cleanse data
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                self.ErrorLabel.text = error!.localizedDescription
                self.ErrorLabel.alpha = 1
            }
            else{
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
                HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
            
        }
        
        
    }
    
}
