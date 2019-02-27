//
//  ExtensionView.swift
//  Apple ou pas
//
//  Created by Fabrice on 15/02/2019.
//  Copyright © 2019 Fabrice. All rights reserved.
//

import UIKit

extension UIView {
    
    func setlayer() {
        backgroundColor = .white
        layer.cornerRadius = 10
        //layer.borderColor = UIColor.red.cgColor
        //layer.borderWidth = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
}
