//
//  ViewController.swift
//  seTgamE
//
//  Created by user145418 on 10/21/18.
//  Copyright © 2018 user145418. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = SetGame()
    var hints = [SetCard]()
    var gameBoard = [CardView: SetCard]()
    var matchedCardsOnBoard = false
   
    @IBOutlet weak var boardview: BoardView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var showMatches: UIButton!
    
    @IBOutlet weak var deal3Cards: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealCards()
        updateUI()
    }
    @IBAction func deal3Cards(_ sender: UIButton) {
        dealCards()
        updateUI()
        
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        gameBoard.removeAll()
        boardview.cardviews.removeAll()
        startGame()
        updateUI()    }
    
    @IBAction func showMatches(_ sender: UIButton) {
        if game.cards.count == 0 {
            removeMatchedCards()
        }
        if hints.count > 0 {        // already asked for a hint
            game.choseCard(card: hints.removeFirst())
            updateUI()
        } else if let set = game.setOfCards(){
            hints = set
            game.choseCard(card: hints.removeFirst())
            updateUI()
        }    }

    func removeMatchedCards() {
        // remove any matched cards from tableau
        if matchedCardsOnBoard {
            for (cardView, card) in gameBoard {
                if game.cardsMatched.contains(card) {
                    boardview.cardviews = boardview.cardviews.filter { $0 != cardView}
                    gameBoard.removeValue(forKey: cardView)
                }
            }
        }
    }
    func ShowCardView(fromCard card: SetCard) -> CardView {
        let cardView = CardView()
        
        switch card.shape {
        case .squiggle: cardView.cardShape = .sqiggle
        case .oval: cardView.cardShape = .oval
        case .diamond: cardView.cardShape = .diamond
        }
        
        switch card.shading {
        case .outlined: cardView.cardShade = .outlined
        case .solid: cardView.cardShade = .solid
        case .striped: cardView.cardShade = .stripes
        }
        
        cardView.numOfShapes = card.number.rawValue
        
        switch card.color {
        case .red: cardView.color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .purple: cardView.color = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case .green: cardView.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return cardView
    }
    
    func startGame() {
       dealCards()
    }
    func setButtonColor(button: UIView, color: UIColor) {
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 4.0
    }
    func clearBorder(button: UIView) {
        button.layer.borderWidth = 0
        button.layer.borderColor = nil
    }
    
    func updateUI() {
        matchedCardsOnBoard = false
        for (cardView, card) in gameBoard {
            cardView.cardSelected = game.cardsSelectd.contains(card)
            cardView.cardMisMatched = game.misMatchedSetCards.contains(card)
            
            if game.cardsMatched.contains(card) {
                cardView.cardMatched = true
                matchedCardsOnBoard = true
            }
        }
        
        scoreLabel.text = "Score:\(game.score)"
        
        showMatches.isHidden = (game.setOfCards() == nil)
        
        if game.cards.count == 0 {
            deal3Cards.isHidden = true
        }
        
    }
    @objc func cardTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let cardView = sender.view as! CardView
            if let setCard = gameBoard[cardView] {
                game.choseCard(card: setCard)
            }
            hints.removeAll()   // hints no longer valid
            updateUI()
        }
}
    @IBAction func swipeToDeal3Cards(_ sender: UISwipeGestureRecognizer) {
        dealCards()
        updateUI()
        
    }
    func dealCards() {
        removeMatchedCards()
        let numOfCardsToDeal = max(3, 12 - boardview.cardviews.count)
        
        for _ in 1...numOfCardsToDeal {
            if let card = game.drawOneCard() {
                let cardView = ShowCardView(fromCard: card)
                let tap = UITapGestureRecognizer(target: self, action: #selector(cardTap))
                cardView.addGestureRecognizer(tap)
                gameBoard[cardView] = card
                boardview.cardviews.append(cardView)
            }
        }
    }
    
    @IBAction func deal3CardsButton(_ sender: UIButton) {
        dealCards()
        updateUI()
    }
   
    
}
