//
//  ViewController.swift
//  set_lab3
//
//  Created by Sunny Guduru on 7/26/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Place a SetCardView on the root view
        let setCard = SetCardView(frame: CGRect(x: 0, y: 100, width: 200, height: 150))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCard(_:)))
        setCard.addGestureRecognizer(tap)
        
        self.view.addSubview(setCard)
        // Do any additional setup after loading the view.
    }
    
    @objc func tappedCard(_ sender: UITapGestureRecognizer) {
         if let card = sender.view as! SetCardView? {
            card.selected = !card.selected
        }
    }

}

