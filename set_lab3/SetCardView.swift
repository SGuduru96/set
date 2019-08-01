//
//  SetCardView.swift
//  set_lab3
//
//  Created by Sunny Guduru on 7/26/19.
//  Copyright © 2019 Sunny Guduru. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    @IBInspectable var number: Int = 1 {
        didSet {
            if number < 1 {
              number = 1
            } else if number > 3  {
                number = 3
            }
            
            setNeedsDisplay()
        }
    }
    
    var shape: Shape = .oval { didSet { setNeedsDisplay() } }
    
//    @IBInspectable var inspectableShape: Int {
//        get {
//            switch shape {
//            case .diamond: return 0
//            case .squiggle: return 1
//            case .oval: return 2
//            }
//        }
//
//        set {
//            switch newValue {
//            case 1: shape = .diamond
//            case 2: shape = .squiggle
//            case 3: shape = .oval
//            default: shape = .oval
//            }
//        }
//    }
    
    @IBInspectable var color: UIColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) { didSet{ setNeedsDisplay() } }
    var shade: Shade = .open { didSet{ setNeedsDisplay() } }
    
//    @IBInspectable var inspectableShade: Int {
//        get {
//            switch shade {
//            case .solid: return 0
//            case .striped: return 1
//            case .open: return 2
//            }
//        }
//        
//        set {
//            switch newValue {
//            case 1: shade = .solid
//            case 2: shade = .striped
//            case 3: shade = .open
//            default: shade = .open
//            }
//        }
//    }
    
    var selected = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            selected = !selected
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if selected {
            self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            self.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        print(cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        // Define x coordiates for the shape(s)
        var xPositionsForShapes = [CGFloat]()
        switch number {
        case 1:
            xPositionsForShapes += [bounds.midX]
        case 2:
            xPositionsForShapes += [CGFloat(bounds.midX - shapeWidth.half - paddingBetweenShapes), CGFloat(bounds.midX + shapeWidth.half + paddingBetweenShapes)]
        case 3:
            xPositionsForShapes += [CGFloat(bounds.midX - shapeWidth - paddingBetweenShapes), bounds.midX, CGFloat(bounds.midX + shapeWidth + paddingBetweenShapes)]
        default:
            assert(false, "Card number is not in the range of 1...3")
        }
        
        // Define the bounds given the x coordinates
        var shapeBounds = [CGRect]()
        xPositionsForShapes.forEach({
            shapeBounds.append(CGRect(x: $0 - shapeWidth.half, y: bounds.midY - shapeHeight.half, width: shapeWidth, height: shapeHeight))
        })
        
        // Draw and clip the shapes
        let path = clip(withInBounds: shapeBounds)
        // Fill with the pattern
        shade(patternInPath: path)
    }
    
    func shade(patternInPath path: UIBezierPath) {
        color.setStroke()
        color.setFill()
        path.lineWidth = 2
        switch shade {
        case .open:
            path.stroke()
        case .solid:
            path.fill()
        case .striped:
            let numLines = 25
            path.lineWidth = 4
            let spaceBetweenLines = bounds.width / CGFloat(numLines)
            for i in 1...numLines {
                let lineAlong = spaceBetweenLines * CGFloat(i)
                path.move(to: CGPoint(x: lineAlong, y: 0.0))
                path.addLine(to: CGPoint(x: lineAlong, y: bounds.height))
                
            }
            path.stroke()
        }
    }
    
    func clip(withInBounds shapeBounds: [CGRect]) -> UIBezierPath {
        let clipPath = UIBezierPath()
        shapeBounds.forEach({
            switch shape {
            case .oval:
                clipPath.addRoundedRect(inRect: $0, withCornerRadius: shapeCornerRadius)
            case .diamond:
                clipPath.addDiamond(inRect: $0)
            case .squiggle:
                clipPath.addSquiggle(inRect: $0)
            }
        })
        
        clipPath.addClip()
        return clipPath
    }

    enum Shape: Int {
        case diamond
        case squiggle
        case oval
    }
    
    enum Shade: Int {
        case solid
        case striped
        case open
    }
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let shapeSize = CGSize(width: 1.0 / 5.0, height: 2.0 / 3.0)
        static let paddingBetweenShapes = CGFloat(1.0/25.0)
        static let shapeCornerRadius: CGFloat = 0.5
    }
    
    private var shapeWidth: CGFloat {
        return bounds.width * SizeRatio.shapeSize.width
    }
    
    private var shapeHeight: CGFloat {
        return bounds.height * SizeRatio.shapeSize.height
    }
    
    private var paddingBetweenShapes: CGFloat {
        return bounds.width * SizeRatio.paddingBetweenShapes
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var shapeCornerRadius: CGFloat {
        return shapeWidth * SizeRatio.shapeCornerRadius
    }
}

extension CGFloat {
    var half: CGFloat {
        return self * CGFloat(0.5)
    }
}

extension UIBezierPath {
    func addDiamond(inRect rect: CGRect) {
        self.move(to: CGPoint(x: rect.midX, y: rect.minY))
        self.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        self.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        self.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        self.close()
    }
    
    func addSquiggle(inRect rect: CGRect) {
        self.move(to: CGPoint(x: rect.midX, y: rect.minY))
        self.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY), controlPoint1: CGPoint(x: rect.minX, y: rect.minY), controlPoint2: CGPoint(x: rect.maxX - 10, y: rect.maxY))
        self.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), controlPoint1: CGPoint(x: rect.maxX + 20, y: rect.maxY), controlPoint2: CGPoint(x: rect.minX + 15, y: rect.minY))
        self.close()
    }
    
    func addRoundedRect(inRect rect: CGRect, withCornerRadius cornerRadius: CGFloat) {
        self.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        self.addArc(withCenter: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3.0 / 2.0, clockwise: true)
        self.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        self.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi * 3.0 / 2.0, endAngle: CGFloat(0), clockwise: true)
        self.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        self.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: CGFloat(0), endAngle: CGFloat.pi * 1.0 / 2.0, clockwise: true)
        self.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        self.addArc(withCenter: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi * 1.0 / 2.0, endAngle: CGFloat.pi, clockwise: true)
        self.close()
    }
}
