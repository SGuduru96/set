//
//  Card.swift
//  set
//
//  Created by Sunny Guduru on 7/8/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import Foundation

struct SetCard: Equatable {
    let numberOfShapes: Number
    let shape: Shape
    let shade: Shade
    let color: Color
    
    init(_ numShapes: Number, _ shape: Shape, _ shade: Shade, _ color: Color) {
        
        numberOfShapes = numShapes
        self.shape = shape
        self.shade = shade
        self.color = color
    }
    
    func match(with cardTwo: SetCard, and cardThree: SetCard) -> Bool {
        
        let numCondition = (self.numberOfShapes == cardTwo.numberOfShapes && self.numberOfShapes == cardThree.numberOfShapes) || (self.numberOfShapes != cardTwo.numberOfShapes && self.numberOfShapes != cardThree.numberOfShapes)
        
        let shapeCondition = (self.shape == cardTwo.shape && self.shape == cardThree.shape) || (self.shape != cardTwo.shape && self.shape != cardThree.shape)
        
        let shadeCondition = (self.shade == cardTwo.shade && self.shade == cardThree.shade) || (self.shade != cardTwo.shade && self.shade != cardThree.shade)
        
        let colorCondition = (self.color == cardTwo.color && self.color == cardThree.color) || (self.color != cardTwo.color && self.color != cardThree.color)
        
        return numCondition && shapeCondition && shadeCondition && colorCondition
    }
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.numberOfShapes == rhs.numberOfShapes && lhs.shape == rhs.shape && lhs.shade == rhs.shade && lhs.color == rhs.color
    }
    
    static func !=(lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.numberOfShapes != rhs.numberOfShapes || lhs.shape != rhs.shape || lhs.shade != rhs.shade || lhs.color != rhs.color
    }
    
    enum Number: CaseIterable {
        case one
        case two
        case three
        
        static let all = [Number.one, .two, .three]
    }
    
    enum Shape: CaseIterable {
        case diamond
        case squiggle
        case oval
        
        static let all = [Shape.diamond, .squiggle, .oval]
    }
    
    enum Shade: CaseIterable {
        case solid
        case striped
        case open
        
        static let all = [Shade.solid, .striped, .open]
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case purple
        
        static let all = [Color.red, .green, .purple]
    }
}
