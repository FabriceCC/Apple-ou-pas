//
//  MonButton.swift
//  Apple ou pas
//
//  Created by Fabrice on 15/02/2019.
//  Copyright © 2019 Fabrice. All rights reserved.
//

import UIKit

class MonButton: UIButton {

    // Pour déclarer une nouvelle classe et l'initialiser (Override init (init au cliq), super.init, required init (init programmatique), setup (base de déclaration)
    
   

    func setup(string: String){
        setlayer()
        setTitle(string, for: UIControl.State.normal)
        setTitleColor(UIColor.red, for: .normal)
        
    }


}



