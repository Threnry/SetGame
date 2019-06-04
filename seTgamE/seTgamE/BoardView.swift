//
//  BoardView.swift
//  seTgamE
//
//  Created by user145418 on 10/28/18.
//  Copyright © 2018 user145418. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var cardviews = [CardView](){didSet{layoutSubviews()}}
    private var grid = Grid(layout: Grid.Layout.aspectRatio(3/3.5))

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture))
        self.addGestureRecognizer(rotateGesture)
    }
    override func layoutSubviews() {
        self.backgroundColor = UIColor.green
        grid.frame = bounds
        grid.cellCount = cardviews.count
        
        // remove all subviews
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        for ViewIndex in cardviews.indices {
            let cardView = cardviews[ViewIndex]
            cardView.frame = grid[ViewIndex]!.zoom(by: 0.95)
            addSubview(cardviews[ViewIndex])
        }
        
    }
    @objc func handleRotateGesture(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began: break
        case .changed: cardviews.shuffle()
        case .ended: break
        default: break
        }
        
}
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
}
