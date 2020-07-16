//
//  SignUpViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 6/7/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //Hide the error Label
        errorLabel.alpha = 0
        
        // style elements
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String? {
        // check all fields filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        // check password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is 8 characters, contains a special character, and a number."
        }
        
        return nil
        
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            showError(message: error!)
            
        }
        else{
            // create cleaned version of data
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            
            if err != nil{
                self.showError(message: "Error Creating User")
                
            }
            else{
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstname" : firstname, "lastname":lastname, "uid":result!.user.uid]){ (error) in
                        if error != nil {
                        self.showError(message: "Error saving user data.")
                        }
                    }
                
                self.transistionToHome()
                }
        }
        
    }
}
    func transistionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    func showError(message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
