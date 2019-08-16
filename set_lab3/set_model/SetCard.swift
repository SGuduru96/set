//
//  Card.swift
//  set
//
//  Created by Sunny Guduru on 7/8/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import Foundation

struct SetCard: Equatable, RawRepresentable {
    typealias RawValue = String
    var rawValue: RawValue {
        get {
            var value = ""
            
            switch numberOfShapes {
            case .one:
                value += "1"
            case .two:
                value += "2"
            case .three:
                value += "3"
            }
            
            switch shape {
            case .diamond:
                value += "d"
            case .oval:
                value += "o"
            case.squiggle:
                value += "s"
            }
            
            switch shade {
            case .open:
                value += "op"
            case .solid:
                value += "so"
            case .striped:
                value += "st"
            }
            
            switch color {
            case .red:
                value += "r"
            case .green:
                value += "g"
            case .purple:
                value += "p"
            }
            
            return value
        }
    }
    
    var numberOfShapes: Number
    var shape: Shape
    var shade: Shade
    var color: Color
    
    init(_ numShapes: Number, _ shape: Shape, _ shade: Shade, _ color: Color) {
        
        numberOfShapes = numShapes
        self.shape = shape
        self.shade = shade
        self.color = color
    }
    
    init?(rawValue: String) {
        let chars = Array(rawValue)
        
        // defaults for fail
        numberOfShapes = .one
        shape = .diamond
        shade = .open
        color = .green
        
        // number of shapes
        switch chars[0] {
        case "1":
            numberOfShapes = .one
        case "2":
            numberOfShapes = .two
        case "3":
            numberOfShapes = .three
        default:
            assert(false, "rawValue[0]: \(chars[0]) has to be 1, 2, or 3.")
        }
        
        // shape
        switch chars[1] {
        case "d":
            shape = .diamond
        case "o":
            shape = .oval
        case "s":
            shape = .squiggle
        default:
            assert(false, "rawValue[1]: \(chars[1]) has to be d, o, or s.")
        }
        
        // shade
        switch chars[2..<4] {
        case ["o","p"]:
            shade = .open
        case ["s", "o"]:
            shade = .solid
        case ["s", "t"]:
            shade = .striped
        default:
            assert(false, "rawValue[2..<4]: \(chars[2..<4]) has to be op, so, or st.")
        }
        
        // color
        switch chars[4] {
        case "r":
            color = .red
        case "g":
            color = .green
        case "p":
            color = .purple
        default:
            assert(false, "rawValue[4]: \(chars[4]) has to be r, g, or p.")
        }
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
}

enum Number: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    
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
