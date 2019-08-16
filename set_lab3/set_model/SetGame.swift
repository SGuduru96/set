//
//  Set.swift
//  set
//
//  Created by Sunny Guduru on 7/8/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import Foundation

class SetGame {
    private(set) var cardDeck = SetDeck()
    private(set) var dealtCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private var startingDeal: () -> Bool = {return false}
    var dealThreeCards: () -> Bool = {return false}
    private(set) var startingNumberOfCards: Int
    var matchState = MatchState.none

    var score: Int = 0 {
        didSet {
            if score < 0 { score = 0 }
        }
    }
    
    init(withNumberOfCards numCards: Int) {
        startingNumberOfCards = numCards
        startingDeal = createDealFunction(whichDeals: numCards)
        dealThreeCards = createDealFunction(whichDeals: 3)
        let dealt = startingDeal()
        assert(dealt, "Starting Deal of \(startingNumberOfCards) failed.")
    }
    
    
    func resetGame() {
        cardDeck = SetDeck()
        selectedCards = [SetCard]()
        matchedCards = [SetCard]()
        score = 0
        dealtCards = [SetCard]()
        let dealt = startingDeal()
        assert(dealt, "Starting Deal of \(startingNumberOfCards) failed.")
    }
    
    func createDealFunction(whichDeals numCards: Int) -> () -> Bool {
        return {
            if self.cardDeck.count >= numCards {
                var dealing = [SetCard]()
                
                for _ in 1...numCards {
                    if let card = self.cardDeck.draw() {
                        dealing.append(card)
                    } else {
                        break
                    }
                }
                
                self.dealtCards += dealing
                return true
            }
            return false
        }
    }
    
    func chooseCard(at index: Int) {
        let card = dealtCards[index]
        
        if matchState != .none {
            matchState = .none
        }
        
        // Unselect card it was previously selected
        if let indexInSelectedCards = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: indexInSelectedCards) // Remove the selected card from selectedCards array
        } else {
            selectedCards.append(card) // Add selected card to selectedCards array
            
            // If there are 3 or more cards, then check if they match
            if selectedCards.count > 2 {
                matchingSelection(in: selectedCards) ? match() : notMatch()
                selectedCards = [SetCard]() // Clear the selectedCards
            }
        }
    }
    
    private func match() {
        score += 1
        
        for card in selectedCards {
            // add to matched card
            matchedCards.append(card)
            
            // remove or replace card
            let indexInDealtCards = dealtCards.firstIndex(of: card)!
            if let newCard = cardDeck.draw(), dealtCards.count <= startingNumberOfCards {
                dealtCards[indexInDealtCards] = newCard
            } else {
                dealtCards.remove(at: indexInDealtCards)
            }
        }
        
        matchState = .match
    }
    
    private func notMatch() {
        score -= 1
        matchState = .fail
    }
    
    private func matchingSelection(in selectedCards: [SetCard]) -> Bool {
        if selectedCards[0].match(with: selectedCards[1], and: selectedCards[2]) {
            return true
        }
        return false
    }
    
    enum MatchState {
        case match
        case fail
        case none
    }
}

extension SetGame {
    func test() {
        print("-------init(withNumberOfCards: Int) TEST-------")
        var test1 = dealtCards.count == 12
        var test2 = cardDeck.count == 81 - 12
        var test3: Bool
        var test4 = matchedCards.count == 0
        var test5 = selectedCards.count == 0
        var test6 = score == 0
        print("let game = Set(withNumberOfCards: 12)")
        print("set.dealtCards.count == 12 -> \(test1)")
        print("set.cardDeck.count == 69 -> \(test2)")
        print("set.matchedCards.count == 0 -> \(test4)")
        print("set.selectedCards.count == 0 -> \(test5)")
        print("set.score == 0 -> \(test6)")
        print()
        assert(test1)
        assert(test2)
        assert(test4)
        assert(test5)
        assert(test6)
        
        print("-------chooseCard(at index: Int) MATCHING TEST-------")
        chooseCard(at: 0)
        chooseCard(at: 1)
        chooseCard(at: 2)
        test4 = score == 1
        test5 = selectedCards.count == 3
        test6 = matchedCards.count == 0
        //        var test7 = matchState == .success
        print("score == 1 -> \(test4)")
        print("selectedCards.count == 3 -> \(test5)")
        print("matchedCards.count == 0 -> \(test6)")
        //        print("matchState == .success -> \(test7)")
        print()
        assert(test4)
        assert(test5)
        assert(test6)
        
        print("-------AFTER MATCH TEST-------")
        chooseCard(at: 3)
        test2 = selectedCards.count == 1
        test3 = matchedCards.count == 3
        //        test4 = matchState == .none
        print("seletedCards.count == 1 -> \(test2)")
        print("matchedCards.count == 3 -> \(test3)")
        //        print("matchState == .none -> \(test4)")
        print()
        assert(test2)
        assert(test3)
        //        assert(test4)
        
        print("-------MATCH FAIL TEST-------")
        chooseCard(at: 5)
        chooseCard(at: 9)
        test1 = selectedCards.count == 3
        test2 = matchedCards.count == 3
        print("selectedCards.count == 3 -> \(test1)")
        print("matchedCards.count == 3 -> \(test2)")
        print()
        assert(test1)
        assert(test2)
        
        print("-------AFTER MATCH FAIL TEST-------")
        chooseCard(at: 3)
        test2 = selectedCards.count == 1
        test3 = matchedCards.count == 3
        print("seletedCards.count == 1 -> \(test2)")
        print("matchedCards.count == 3 -> \(test3)")
        print()
        assert(test2)
        assert(test3)
        assert(test4)
        
        print("-------chooseCard(at: Int) DESELECTION TEST-------")
        chooseCard(at: 3) // Deselect Card
        test1 = selectedCards.count == 0
        print("chooseCard(at: 3)")
        print("selectedCard.count = 0 -> \(test1)")
        print()
        assert(test1)
        
        print("-------addThreeCards() EMPTY DECK TEST-------")
        cardDeck = SetDeck()
        test1 = dealThreeCards() == false
        test2 = cardDeck.count == 0
        
        let numberOfDealtCards = dealtCards.count
        chooseCard(at: 0)
        chooseCard(at: 1)
        chooseCard(at: 2)
        chooseCard(at: 3)
        test3 = dealtCards.count == numberOfDealtCards - 3
        
        print("cardDeck = [Card]()")
        print("dealThreeCards() == false -> \(test1)")
        print("cardDeck.count == 0 -> \(test2)")
        print("dealtCards.count == numberOfDealtCards - 3 -> \(test3)")
        print()
        assert(test1)
        assert(test2)
        assert(test3)
        //chooseCard(at: 3) // Deselect Card
        
        
        print("-------resetGame() TEST-------")
        resetGame()
        test1 = dealtCards.count == 12
        test2 = cardDeck.count == 81 - 12
        test4 = matchedCards.count == 0
        test5 = selectedCards.count == 0
        test6 = score == 0
        print("let game = Set(withNumberOfCards: 12)")
        print("set.dealtCards.count == 12 -> \(test1)")
        print("set.cardDeck.count == 69 -> \(test2)")
        print("set.matchedCards.count == 0 -> \(test4)")
        print("set.selectedCards.count == 0 -> \(test5)")
        print("set.score == 0 -> \(test6)")
        print()
        assert(test1)
        assert(test2)
        assert(test4)
        assert(test5)
        assert(test6)
        
    }
}
