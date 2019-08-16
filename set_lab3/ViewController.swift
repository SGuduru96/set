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
    @IBOutlet weak var dealCardsButton: UIButton!
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
            createCards()
        }
    }
    
    private func updateViewFromModel() {
        // update grid cellcount
        grid.cellCount = game.dealtCards.count
        
        // If there is a match, we need to remove matched cards from listOfCardViews
        if game.matchState == .match {
            var recentlyMatchedCards = game.matchedCards
            if recentlyMatchedCards.count > 3 {
                recentlyMatchedCards = Array(game.matchedCards[game.matchedCards.count - 4..<game.matchedCards.count])
            }
            
            // map to rawValues
            let cardIdsToRemove = recentlyMatchedCards.map { $0.rawValue }
            
            // filter out cardIdsToRemove
            listOfSetCardViews = listOfSetCardViews.filter {
                if !cardIdsToRemove.contains($0.identification) {
                    return true
                }
                $0.removeFromSuperview()
                return false
            }
        }
        
        // Lets match the number of cards
        while game.dealtCards.count > listOfSetCardViews.count {
            let cardView = createCardAndSetup(withFrame: grid[listOfSetCardViews.count]!)
            listOfSetCardViews.append(cardView)
            playingFieldView.addSubview(cardView)
        }
        
        // Configure each cardView with properties from the game.dealtCards
        var currentIndex = 0
        while currentIndex < listOfSetCardViews.count {
            setProperties(forCardView: listOfSetCardViews[currentIndex], fromCardModel: game.dealtCards[currentIndex])
            currentIndex += 1
        }
        
        updateCardFramesFromGrid()
    }

    private func updateCardFramesFromGrid() {
        for cardIndex in listOfSetCardViews.indices {
            if let cardFrameInGrid = grid[cardIndex]?.insetBy(dx: 8, dy: 8) {
                listOfSetCardViews[cardIndex].frame = cardFrameInGrid
            }
        }
    }
    
    private func createCards() {
        for cardIndex in game.dealtCards.indices {
            let cardView = createCardAndSetup(withFrame: grid[cardIndex]!)
            setProperties(forCardView: cardView, fromCardModel: game.dealtCards[cardIndex])
            listOfSetCardViews.append(cardView)
            playingFieldView.addSubview(cardView)
        }
//        (0..<grid.cellCount).forEach {
//            if grid[$0] != nil {
//                createCardAndSetup(withFrame: grid[$0]!)
//            }
//        }
    }
    
    private func setProperties(forCardView cardView: SetCardView, fromCardModel cardModel: SetCard) {
        var color = UIColor()
        switch cardModel.color {
        case .red: color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .green: color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .purple: color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
        
        cardView.setCardProperties(toNumber: cardModel.numberOfShapes, ofShape: cardModel.shape, withShade: cardModel.shade, ofColor: color, withIdentification: cardModel.rawValue)
    }
    
    private func createCardAndSetup(withFrame cardFrame: CGRect) -> SetCardView {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCard(_:)))
        let setCard = SetCardView(frame: cardFrame.insetBy(dx: 8, dy: 8))
        setCard.addGestureRecognizer(tap)
        return setCard
    }
    
    @objc func tappedCard(_ sender: UITapGestureRecognizer) {
         if let card = sender.view as! SetCardView? {
            card.selected = !card.selected
            
            // find the index of card in listOfSetCardViews
            if let cardNumber = listOfSetCardViews.firstIndex(of: card) {
                game.chooseCard(at: cardNumber)
            }
            
            updateViewFromModel()
        }
    }
    
    @IBAction func dealThreeCards(_ sender: UIButton) {
        if game.dealThreeCards() {
            updateViewFromModel()
        } else {
            dealCardsButton.isEnabled = false
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update grid frame and then change card frames
        grid.frame = playingFieldView.bounds
        updateCardFramesFromGrid()
    }
}

