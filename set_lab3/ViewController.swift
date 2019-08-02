//
//  ViewController.swift
//  set_lab3
//
//  Created by Sunny Guduru on 7/26/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playingFieldView: UIView!
    private var startingNumberOfCards = 3
    private var listOfSetCardViews = [SetCardView]()
    lazy var setGame = SetGame(withNumberOfCards: startingNumberOfCards)
    lazy private var grid = Grid(layout: Grid.Layout.aspectRatio(1.5), frame: playingFieldView.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        grid.cellCount = startingNumberOfCards
        
        for i in 0..<startingNumberOfCards {
            if let frame = grid[i] {
                createCardAndSetup(withFrame: frame)
            }
        }
    }
    
    /*
     Creates a SetCardView given it's properties.
     Adds a tap gesture recognizer to it.
     Finally, adds the view to listOfSetCardViews
     and as a suview of thePlayingFieldView.
     */
    func createCardAndSetup(withFrame frame: CGRect) {
        //TODO: use .inset() on frame to add space between cards
        let setCard = SetCardView(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCard(_:)))
        setCard.addGestureRecognizer(tap)
        listOfSetCardViews.append(setCard)
        playingFieldView.addSubview(setCard)
    }
    
    @objc func tappedCard(_ sender: UITapGestureRecognizer) {
         if let card = sender.view as! SetCardView? {
            card.selected = !card.selected
        }
    }

}

