//
//  CreateActVC.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/27/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import YPImagePicker
import PMAlertController

class CreateActVC: UIViewController, UITextFieldDelegate{

    var keyboardHeight: CGFloat!
    var firstTime = true
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var IdField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstTime{
            let alertVC = PMAlertController(title: "Hmm... first time?", description: "Now let's get you all set up..", image: UIImage(named: "cute.png"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Continue", style: .default, action: { () in
                print("Capture action OK")
            }))
            
            self.present(alertVC, animated: true, completion: nil)
            firstTime = false
        }

    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        var errorString: String?
        
        if (firstNameField.text == "" || lastNameField.text == "" || emailField.text == "" || passwordField.text == "" || IdField.text == ""){
            
            errorString = "Important field missing"
        }
            
        else if(IdField.text?.count != 9){
            errorString = "Wrong student ID"
        }
        else if(emailField.text?.lowercased().range(of:"mvsu.edu") == nil){
            errorString = "Only MVSU emails accepted"
            
        }
        else{
            if let email = emailField.text, let pwd = passwordField.text{
                Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil {
                        print("HENRY: Unable to create user with firebase using email")
                        
                        let alertVC = PMAlertController(title: "Error signing in", description: (error?.localizedDescription)!, image: nil, style: .alert)
                        
                        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                            print("Capture action OK")
                            self.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alertVC, animated: true, completion: nil)
                        
                        //self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .center)
                    }
                    else{
                        print("HENRY: User successfully created with FIR")
                        if let user = user{
                            user.sendEmailVerification(completion: { (error) in
                                print("\(error?.localizedDescription)")
                            })
                            
                            let alertVC = PMAlertController(title: "Sign up complete!", description: "Go unto your Valley email to verify your account", image: nil, style: .alert)
                            
                            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                                print("Capture action OK")
                                self.dismiss(animated: true, completion: nil)
                                
                                self.dismissVC()
                            }))
                            
                            self.present(alertVC, animated: true, completion: nil)
                            
                            self.completeSignIn(id: user.uid)
                        }
                    }
                })
                
            }
        }
        if let error = errorString{
            let alertVC = PMAlertController(title: "Error signing in", description: error, image: nil, style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                print("Capture action OK")
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func returnData() -> Dictionary<String, String>{
        let fname = firstNameField.text
        let lname = lastNameField.text
        let email = emailField.text
        let studentID = IdField.text
        let devicetoken = InstanceID.instanceID().token()!
        var dataArray = Dictionary<String, String>()
        
        dataArray.updateValue(devicetoken, forKey: "fcmToken")
        dataArray.updateValue(fname!, forKey: "FirstName")
        dataArray.updateValue(lname!, forKey: "LastName")
        dataArray.updateValue(email!, forKey: "Email")
        dataArray.updateValue(studentID!, forKey: "ID Number")
        
        return dataArray
    }
    
    
    func completeSignIn(id: String){
        let userData = returnData()
        print(userData)
        DataServices.ds.createUsers(uid: id, data: userData)
    }
    
    @IBAction func imageBtnPressed(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromLibrary = true
        config.onlySquareImagesFromCamera = true
        config.libraryTargetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        config.albumName = "One V"
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)

        picker.didSelectImage = { [unowned picker] img in
            // image picked
            print(img.size)
            self.imageView.image = img
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)

    }
    
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func backToLogin(_ sender: Any) {
        dismissVC()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(CGPoint(x:0, y:216), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
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
