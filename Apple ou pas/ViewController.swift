//
//  ViewController.swift
//  Apple ou pas
//
//  Created by Fabrice on 12/02/2019.
//  Copyright © 2019 Fabrice. All rights reserved.
//

import UIKit
import AVFoundation // pour jouer du son

class ViewController: UIViewController {

    
    @IBOutlet weak var container: UIView!
    
    var carte: MaVue?
    var rect = CGRect()
    var boutonOui = MonButton()
    var boutonNon = MonButton()
    var boutonPlay: MonButton?
    var scoreLabel = MonLabel()
    var timer = Timer()
    var audioPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    var isGame = false
    var tempsRestant = 0
    var score = 0
    
    let ouiSon = Son(nom: "oui", ext: "wav")
    let nonSon = Son(nom: "non", ext: "mp3")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creationGradient()
        container.frame = view.bounds
        rect = CGRect(x: container.frame.midX - 100, y: container.frame.midY - 100, width: 200,height: 200)
        creationBouton()
        creationLabel()
        setupGame()
        
    }

    func creationLabel() {
        scoreLabel = MonLabel(frame: CGRect(x:20, y:10, width: container.frame.width - 40, height: 60))
        container.addSubview(scoreLabel)
        
    }
    
    
    
    
    
    func creationBouton() {
        let tiers = container.frame.width / 3
        let quart = container.frame.width / 4
        let hauteur: CGFloat = 50
        let y = container.frame.height - (hauteur * 1.5)
        let taille = CGSize(width: tiers, height: hauteur)
        
        // création boutons
        
        boutonOui.frame.size = taille
        boutonOui.center = CGPoint(x: quart * 3 , y: y)
        boutonOui.setup(string: "OUI")
        boutonOui.addTarget(self, action: #selector(oui), for: .touchUpInside)
        container.addSubview(boutonOui)
        boutonOui.isHidden = true
        
        
        boutonNon.frame.size = taille
        boutonNon.center = CGPoint(x: quart, y: y)
        boutonNon.setup(string: "NON")
        boutonNon.addTarget(self, action: #selector(non), for: .touchUpInside)
        container.addSubview(boutonNon)
        boutonNon.isHidden = true
        
    }
    
    func creationGradient() {
        
        // créer un dégradé sur le container
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        view.bringSubviewToFront(container)
        
        
    }
    
    
    func setupGame() {
        if isGame {
            
            if boutonPlay != nil {
                boutonPlay?.removeFromSuperview()
                boutonPlay = nil
            }
            
            //ajout carte
            carte = MaVue(frame: rect )
            container.addSubview(carte ?? UIView())
            
            //apparition boutons
            boutonNon.isHidden = false
            boutonOui.isHidden = false
            
            
            let boolRandom = Int.random(in: 0...1) % 2 == 0
            carte?.logo = Logo(bool: boolRandom)
            let son = Son(nom: "tictac", ext: "mp3")
            if let url = Bundle.main.url(forResource: son.nom, withExtension: son.ext) {
                do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = 0
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
            } catch {
                print(error.localizedDescription)
                }
                
            }
        }
        else {
            
            // Test pour véfifier si affiché et enlever
            if carte != nil {
                carte?.removeFromSuperview()
                carte = nil
            }
            score = 0
            boutonPlay = MonButton(frame: CGRect(x: 40, y: container.frame.height / 2  - 30, width: container.frame.width - 80, height: 60))
            boutonPlay?.setup(string: "Commencer à jouer")
            boutonPlay?.addTarget(self, action: #selector(play), for: .touchUpInside)
            
            // Affiche vue dans le container ou sinon (??) une vue vide
            container.addSubview(boutonPlay ?? UIButton())
            boutonNon.isHidden = true
            boutonOui.isHidden = true
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == carte?.masque {
            
            let xPosition = touch.location(in: container).x
            let distance = container.frame.midX - xPosition
            let angle = -distance / 360
            
            carte?.center.x = xPosition
            carte?.transform = CGAffineTransform(rotationAngle: angle)
            
            if distance >= 75 {
                carte?.MasqueCouleur(.non)
                            }
            else if distance <= -75 {
                carte?.MasqueCouleur(.oui)
                            }
            else {carte?.MasqueCouleur(.peutEtre)
        }
    }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == carte?.masque {
            UIView.animate(withDuration: 0.3, animations: {self.carte?.transform = CGAffineTransform.identity
                self.carte?.frame = self.rect }) { (success) in
                    if self.carte?.reponse != .peutEtre {
                    
                        
                    if self.carte?.reponse == .oui {
                       self.oui()
                    }
                    if self.carte?.reponse == .non {
                        self.non()
                        }            }    }}}
    
    func jouerSon (_ son: Son){
        guard let url = Bundle.main.url(forResource: son.nom, withExtension: son.ext) else {
            return
        }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @objc func non(){
        if self.carte?.logo?.isApple == false {
            self.score += 1
            jouerSon(ouiSon)
        } else {
            jouerSon(nonSon)
        }
        scoreLabel.updateText(tempsRestant, score)
        rotation()
    }
    
    @objc func oui() {
        if self.carte?.logo?.isApple == true {
            self.score += 1
            jouerSon(ouiSon)
        } else {
            jouerSon(nonSon)
        }
        scoreLabel.updateText(tempsRestant, score)
        rotation()
    }
    
    @objc func play() {
        isGame = !isGame
        
        setupGame()
        // Timer
        if isGame {
                    tempsRestant = 30
                    timerFunc()
                
            }
        
    }
    
    
    func alerte() {
        // sauvegarder meilleur score de façon permanente
        var best = UserDefaults.standard.integer(forKey: "Score")
        if score > best {
            best = score
            UserDefaults.standard.set(best, forKey: "Score")
            UserDefaults.standard.synchronize()
            
        }
        //Création alerte fin de jeu
        let alert = UIAlertController(title: "C'est fini ", message: "Votre score est de : \(score) \n Le meilleur score est de : \(best)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {(action) in
            self.play()
            
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func rotation() {
        guard carte != nil else {
            return
        }
        carte?.logo = Logo(bool: Int.random(in: 0...1) % 2 == 0)
        UIView.transition(with: carte!, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    
    func timerFunc() {
        
        
        // Timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in self.tempsRestant -= 1
            self.scoreLabel.updateText(self.tempsRestant, self.score)
            if self.tempsRestant == 0 {
                self.timer.invalidate()
                self.scoreLabel.updateText(nil, nil)
                self.audioPlayer?.stop()
                self.alerte()
                
                
                
            }
        })    }
}

