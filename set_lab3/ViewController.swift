//
//  ViewController.swift
//  set_lab3
//
//  Created by Sunny Guduru on 7/26/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var card: SetCardView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(card.handleTap(sender:)))
            card.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

