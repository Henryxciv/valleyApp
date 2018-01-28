//
//  UIViewController + extensions.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/23/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import UIKit

extension UIViewController {
    //function to add tap gesture to view controllers
    func addGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
       
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        self.view.endEditing(true)
    }
    
}
