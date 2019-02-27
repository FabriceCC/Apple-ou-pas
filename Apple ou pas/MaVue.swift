//
//  MaVue.swift
//  Apple ou pas
//
//  Created by Fabrice on 12/02/2019.
//  Copyright © 2019 Fabrice. All rights reserved.
//

import UIKit

class MaVue: UIView {

    var masque = UIView()
    var imageView: UIImageView?
    var reponse = Reponse.peutEtre
    var logo: Logo? {
        didSet {
            guard let l = logo else { return }
            reponse = .peutEtre
            //masque.backgroundColor = .clear ou
            MasqueCouleur(reponse)
            if imageView == nil {
                imageView = UIImageView(frame: bounds)
                imageView?.contentMode = .scaleAspectFit
                addSubview(imageView ?? UIImageView()) //soit elle existe soit il renvoi une UIImageview vide
                sendSubviewToBack(imageView ?? UIImageView())
            }
            imageView?.image = l.image        }
    }
    
   // initialisation par cliq
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    //intialisation programatique
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }

    func ajoutMasque() {
        masque = UIView(frame: bounds)
        masque.backgroundColor = .clear
        masque.alpha = 0.25
        masque.layer.cornerRadius = 20
        addSubview(masque)
    }
    
    
    func setup(){
        setlayer()
        isUserInteractionEnabled = true
        ajoutMasque()
        
    }
    
    
    func MasqueCouleur(_ reponse: Reponse) {
        switch reponse {
        case .oui: masque.backgroundColor = .green
        case .non: masque.backgroundColor = .red
        case .peutEtre: masque.backgroundColor = .clear
            
         }
        self.reponse = reponse
    }
}
