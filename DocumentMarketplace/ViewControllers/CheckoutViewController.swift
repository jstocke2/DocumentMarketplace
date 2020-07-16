//
//  CheckoutViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/14/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions
import FirebaseDatabase
import Firebase

class CheckoutViewController: UIViewController, STPAuthenticationContext {
    var db = Firestore.firestore()
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    
    var paymentIntentClientSecret: String?
    lazy var functions = Functions.functions()

    lazy var cardTextField: STPPaymentCardTextField = {
            let cardTextField = STPPaymentCardTextField()
            return cardTextField
        }()
        lazy var payButton: UIButton = {
            let button = UIButton(type: .custom)
            button.layer.cornerRadius = 5
            button.backgroundColor = .systemBlue
            button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            button.setTitle("Pay", for: .normal)
            button.addTarget(self, action: #selector(pay), for: .touchUpInside)
            return button
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
                view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
                stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            ])
            
            startCheckout()
        }

        @objc
        func pay() {
            
            guard let paymentIntentClientSecret = paymentIntentClientSecret else {
                        return;
                    }
                    // Collect card details
                    let cardParams = cardTextField.cardParams
                    let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
                    paymentIntentParams.paymentMethodParams = paymentMethodParams

                    // Submit the payment
                    let paymentHandler = STPPaymentHandler.shared()
                    paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                        switch (status) {
                        case .failed:
                            self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                            break
                        case .canceled:
                            self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                            break
                        case .succeeded:
                            self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                            break
                        @unknown default:
                            fatalError()
                            break
                        }
                    }
                }
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                if restartDemo {
                    alert.addAction(UIAlertAction(title: "Restart demo", style: .cancel) { _ in
                        self.cardTextField.clear()
                        self.startCheckout()
                    })
                }
                else {
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                }
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    func startCheckout() {
        let arguments = ["amount": 100,"currency": "usd","payment_method":"card"] as [String : Any]
        functions.httpsCallable("createStripePayment").call(arguments) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey] as! String
                print("Error " + message + details)
            }
            // ...
          }
          //if let text = (result?.data as? [String: Any])?["text"] as? String {
            //self.resultField.text = text
            //print("API Call came back with " + text)
          }
        }
}


