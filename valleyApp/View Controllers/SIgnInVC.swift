//
//  SIgnInVC.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/27/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import PMAlertController
import Toast_Swift
import CoreData

class SIgnInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesture()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if firstTime{
//            let alertVC = PMAlertController(title: "Welcome To OneV!", description: "One Goal, One Team, One V", image: UIImage(named: "cute2.png"), style: .alert)
//            
//            alertVC.addAction(PMAlertAction(title: "Continue", style: .default, action: { () in
//                print("Capture action OK")
//            }))
//            
//            self.present(alertVC, animated: true, completion: nil)
//            firstTime = false
//        }
//    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let pwd = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("HENRY: User successfully authenticated with FIR")
                    
                    if let user = user{
                        if user.isEmailVerified{
                            self.completeSignIn(id: user.uid)
                        }
                        else{
                            let alertVC = PMAlertController(title: "Email not verified", description: "Go to your email to verify your oneV account", image: nil, style: .alert)
                            
                            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                                print("Capture action OK")
                            }))
                            
                            self.present(alertVC, animated: true, completion: nil)
                        }
                    }
                }
                else{
                    var errorString = String()
                    if let errCode = AuthErrorCode(rawValue: error!._code){
                        switch errCode {
                            case .missingEmail:
                                errorString = "Email missing"
                            case .invalidEmail:
                                errorString = "Invalid email address"
                            case .wrongPassword:
                                errorString = "Wrong password"
                            case .userNotFound:
                                errorString = "Sorry, account does not exist"
                            default:
                                errorString = error.debugDescription
                        }
                    }
                    let alertVC = PMAlertController(title: "Error signing in", description: errorString, image: nil, style: .alert)
                    
                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                        print("Capture action OK")
                    }))
                    self.present(alertVC, animated: true, completion: nil)

                }
            })
        }
   
    }
    
    func completeSignIn(id: String){
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        
        let userUUID = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        userUUID.setValue(id, forKey: "userUUID")
        
        do {
            try context.save()
        } catch  {
            print("Error Saving to core data")
        }
        performSegue(withIdentifier: "loggedin", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
