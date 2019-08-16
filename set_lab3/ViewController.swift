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
    private var startingNumberOfCards = 12
    private var listOfSetCardViews = [SetCardView]()
    lazy var game = SetGame(withNumberOfCards: startingNumberOfCards)
    lazy private var grid = Grid(layout: Grid.Layout.aspectRatio(1.5), frame: playingFieldView.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let grid know how many cards we will have to display
        grid.cellCount = game.dealtCards.count
        
        // Create cardViews if there are none
        if listOfSetCardViews.isEmpty {
            (0..<grid.cellCount).forEach {
                if grid[$0] != nil {
                    createCardAndSetup(withFrame: grid[$0]!)
                }
            }
        }
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // Configure each cardView with properties from the game.dealtCards
        for cardIndex in listOfSetCardViews.indices {
            let setCard = game.dealtCards[cardIndex]
            let cardView = listOfSetCardViews[cardIndex]

            var color = UIColor()
            switch setCard.color {
            case .red: color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            case .green: color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .purple: color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }

            // Set the current cardView to the properties of the current card from dealtCards
            cardView.setCardProperties(toNumber: setCard.numberOfShapes,
                                       ofShape: setCard.shape,
                                       withShade: setCard.shade,
                                       ofColor: color)

            // Set the frame for the cardView
            if grid[cardIndex] != nil {
                // Add padding by insetting the frame for card
                cardView.frame = grid[cardIndex]!.insetBy(dx: 10, dy: 10)
            }
        }
    }
    
    /*
     Creates a SetCardView given it's properties.
     Adds a tap gesture recognizer to it.
     Finally, adds the view to listOfSetCardViews
     and as a suview of thePlayingFieldView.
     */
    private func createCardAndSetup(withFrame frame: CGRect) {
        let setCard = SetCardView(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCard(_:)))
        setCard.addGestureRecognizer(tap)
        
        listOfSetCardViews.append(setCard)
        playingFieldView.addSubview(setCard)
    }
    
    @objc func tappedCard(_ sender: UITapGestureRecognizer) {
         if let card = sender.view as! SetCardView? {
//            card.selected = !card.selected
            
            // find the index of card in listOfSetCardViews
            if let cardNumber = listOfSetCardViews.firstIndex(of: card) {
                game.chooseCard(at: cardNumber)
            }
        }
    }

}

