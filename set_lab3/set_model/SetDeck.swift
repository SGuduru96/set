//
//  SetDeck.swift
//  set
//
//  Created by Sunny Guduru on 7/22/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import Foundation

struct SetDeck {
    private(set) var cards = [SetCard]()
    private(set) var count = 0
    
    init() {
        for number in Number.all {
            for shape in Shape.all {
                for shade in Shade.all {
                    for color in Color.all {
                        cards.append(SetCard(number, shape, shade, color))
                        count += 1
                    }
                }
            }
        }
    }
    
    mutating func draw() -> SetCard? {
        if cards.count > 0 {
            count -= 1
            return cards.remove(at: cards.count.arc4random)
        }
        return nil
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
