//
//  UIView + extensions.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/23/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import UIKit

extension UIView {
    
    func giveBorderAndColor(){
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
    }
}
