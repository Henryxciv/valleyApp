//
//  FirstPageVC.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/27/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import UIKit
import CoreData

class FirstPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            print("Inside greater than 1")

            if results.count > 0{
                //print("Inside greater than 1")
                for result in results as! [NSManagedObject]{
                    if let uuid = result.value(forKey: "userUUID"){
                        print(uuid)
                        performSegue(withIdentifier: "loggedin", sender: self)
                    }
                }
            }
            else{
                performSegue(withIdentifier: "login", sender: self)
            }
        } catch {
            print("error adding to coredata")
        }
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
