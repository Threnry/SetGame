//
//  CardView.swift
//  seTgamE
//
//  Created by user145418 on 10/28/18.
//  Copyright © 2018 user145418. All rights reserved.
//

import UIKit

class CardView: UIView {
    var path : UIBezierPath? //optional path
    @IBInspectable
    var cardSelected = false { didSet { setNeedsDisplay() }}
    
    @IBInspectable
    var cardMatched = false { didSet { setNeedsDisplay() }}
    
    @IBInspectable
    var cardMisMatched = false { didSet { setNeedsDisplay() }}
    @IBInspectable
    var color =  #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1){ didSet { setNeedsDisplay(); setNeedsLayout()} }
    var numOfShapes = 1 {didSet{setNeedsDisplay(); setNeedsLayout()}}
    // setlayoutviews to adjust layout views of the subview
    var cardShade : CardShading = .solid {didSet{setNeedsDisplay(); setNeedsLayout()}}
    // setneedsdisplay() to notify system to redraw
    enum CardShading{
        case solid
        case outlined
        case stripes
    }
    var cardColor  : CardColor? = .red {didSet{setNeedsDisplay(); setNeedsLayout()}}
    enum CardColor {
        case red
        case purple
        case green
    
    func get() -> UIColor { //get the color
        switch self {
        case .red:
            return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
    }
    }
    
    var cardShape : CardShape = .sqiggle {didSet{setNeedsDisplay(); setNeedsLayout()}}
    enum CardShape {
        case sqiggle
        case diamond
        case oval
    }
    
        
    

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        isOpaque = false
        let backfroundOfCard = UIBezierPath(rect:bounds)
        UIColor.green.setFill()
        backfroundOfCard.fill()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()       // make it a clipping area
        UIColor.white.setFill()
        if cardSelected {
            UIColor.blue.setFill()
        }
        if cardMatched {
            UIColor.green.setFill()
        }
        if cardMisMatched {
            UIColor.red.setFill()
        }
        roundedRect.fill()
        
        drawHelper(shape: cardShape,  num: numOfShapes)
        
    }
    private func drawHelper(shape: CardShape, num: Int){ // func to helper draw func
        
        let size = CGFloat(bounds.maxX / 1.6)
        let space = CGFloat(0)
        var paths = [UIBezierPath]()
        var toGetPath : (CGPoint, CGFloat) -> UIBezierPath
        switch shape{
            case .diamond : toGetPath = drawDiamond
            case .oval : toGetPath = drawOval
            case.sqiggle : toGetPath = drawSiggle
            
            
        }
        switch numOfShapes {
        case 1:
            paths.append(toGetPath(CGPoint(x: bounds.midX, y: bounds.midY), size))
        case 2:
            paths.append(toGetPath(CGPoint(x: bounds.midX-(size/4+space), y: bounds.midY), size))
            paths.append(toGetPath(CGPoint(x: bounds.midX+(size/4+space), y: bounds.midY), size))
        case 3:
            paths.append(toGetPath(CGPoint(x: bounds.midX-((size/4+space)*2), y: bounds.midY), size))
            paths.append(toGetPath(CGPoint(x: bounds.midX, y: bounds.midY), size))
            paths.append(toGetPath(CGPoint(x: bounds.midX+((size/4+space)*2), y: bounds.midY), size))
        default:
            break
        }
        for path in paths {
            switch cardShade {
            case .outlined:
                path.lineWidth = 5.0
                color.setStroke()
                path.stroke()
            case .solid:
                color.setFill()
                path.fill()
            case .stripes:
                path.lineWidth = 5.0
                color.setStroke()
                path.stroke()
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                path.addClip()
                path.lineWidth = 3.0
                for i in stride(from: 0, to: bounds.maxY, by: 10) {
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: bounds.maxX, y: i))
                }
                path.stroke()
                context?.restoreGState()
            }
        }
        
        
        
    }
    private func drawSiggle(Center center: CGPoint, Size size: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        let scaleFactor = size/104
        let shiftX = center.x - (70*scaleFactor/2)
        let shiftY = center.y - (size/2)
        
        path.move(to: CGPoint(x: 15*scaleFactor+shiftX, y: 104*scaleFactor+shiftY))
        path.addCurve(to: CGPoint(x: 54*scaleFactor+shiftX, y: 63*scaleFactor+shiftY), controlPoint1: CGPoint(x: 36.9*scaleFactor+shiftX, y: 112.4*scaleFactor+shiftY),
                      controlPoint2: CGPoint(x: 60.8*scaleFactor+shiftX, y: 89.7*scaleFactor+shiftY))
        path.addCurve(to: CGPoint(x: 53*scaleFactor+shiftX, y: 27*scaleFactor+shiftY), controlPoint1: CGPoint(x: 51.3*scaleFactor+shiftX, y: 52.3*scaleFactor+shiftY),
                      controlPoint2: CGPoint(x: 42*scaleFactor+shiftX, y: 42.2*scaleFactor+shiftY))
        path.addCurve(to: CGPoint(x: 40*scaleFactor+shiftX, y: 5*scaleFactor+shiftY), controlPoint1: CGPoint(x: 65.6*scaleFactor+shiftX, y: 9.6*scaleFactor+shiftY),
                      controlPoint2: CGPoint(x: 58.3*scaleFactor+shiftX, y: 5.4*scaleFactor+shiftY))
        path.addCurve(to: CGPoint(x: 12*scaleFactor+shiftX, y: 36*scaleFactor+shiftY), controlPoint1: CGPoint(x: 22*scaleFactor+shiftX, y: 4.6*scaleFactor+shiftY),
                      controlPoint2: CGPoint(x: 19.1*scaleFactor+shiftX, y: 9.7*scaleFactor+shiftY))
        path.addCurve(to: CGPoint(x: 14*scaleFactor+shiftX, y: 89*scaleFactor+shiftY), controlPoint1: CGPoint(x: 15.2*scaleFactor+shiftX, y: 59.2*scaleFactor+shiftY),
                      controlPoint2: CGPoint(x: 31.5*scaleFactor+shiftX, y: 61.9*scaleFactor+shiftY))
        path.addCurve(to: CGPoint(x: 15*scaleFactor+shiftX, y: 104*scaleFactor+shiftY), controlPoint1: CGPoint(x: 10*scaleFactor+shiftX, y: 95.3*scaleFactor+shiftY),
                      controlPoint2: CGPoint(x: 6.9*scaleFactor+shiftX, y: 100.9*scaleFactor+shiftY))
        
        return path
    }
    private func drawOval(Center center: CGPoint, Size size : CGFloat) -> UIBezierPath{
        
        let radius = size/5
        let height = size/4
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y+height), radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y-height), radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        path.close()
        return path
    }
    private func drawDiamond(Center center:CGPoint, Size size: CGFloat)
         -> UIBezierPath{
        
        let width = size/5.5
        let height = size/2.5
        let path = UIBezierPath()
        path.move(to: CGPoint(x: center.x, y: center.y - height))    // top
        path.addLine(to: CGPoint(x: center.x + width, y: center.y)) // right
        path.addLine(to: CGPoint(x: center.x, y: center.y + height)) // bottom
        path.addLine(to: CGPoint(x: center.x - width, y: center.y)) // left
        path.close()
        return path
    }
    func  createPathRotatedAroundBoundingBoxCenter(path: CGPath, radians: CGFloat) -> CGPath {
        //    CGRect bounds = CGPathGetBoundingBox(path); // might want to use CGPathGetPathBoundingBox
        let bounds = path.boundingBoxOfPath
        
        //    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        //let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        //    CGAffineTransform transform = CGAffineTransformIdentity;
        var transform = CGAffineTransform.identity
            //    transform = CGAffineTransformTranslate(transform, center.x, center.y);
            .translatedBy(x: bounds.midX, y: bounds.midY)
            //    transform = CGAffineTransformRotate(transform, radians);
            //.rotated(by: CGFloat.pi * 2)
            //    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
            .translatedBy(x: -200, y: -200)
        //.translatedBy(x: -center.x, y: center.y)
        
        //    return CGPathCreateCopyByTransformingPath(path, &transform);
        return path.copy(using: &transform)!
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension CardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to sie: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
    
    
    


