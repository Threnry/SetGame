//
//  Setgame.swift
//  seTgamE
//
//  Created by user145418 on 10/29/18.
//  Copyright © 2018 user145418. All rights reserved.
//

import Foundation

struct SetGame {
    
    var cards = [SetCard]()
    var cardsOnBoard = [SetCard]()
    var cardsSelectd = [SetCard]()
    var cardsMatched = [SetCard]()
    var misMatchedSetCards = [SetCard]()
    var matchedSets = 0
    var score = 0
   
    init() {
        for color in SetCard.Color.all {
            for shape in SetCard.Shape.all {
                for number in SetCard.Number.all {
                    for shading in SetCard.Shading.all {
                        let card = SetCard(color: color, shape: shape, number: number, shading: shading)
                        cards.append(card)
                    }
                }
            }
        }
        cards.shuffle()
      
    }
    
    func setOfCards() -> [SetCard]? {
        for first in 0..<cardsOnBoard.count {
            for second in first+1..<cardsOnBoard.count {
                for third in second+1..<cardsOnBoard.count {
                    let cardSet = [cardsOnBoard[first], cardsOnBoard[second], cardsOnBoard[third]]
                    if makeASet(selectedCards: cardSet) {
                        return cardSet
                    }
                }
            }
        }
        return nil
    }
    
    mutating func drawOneCard() -> SetCard? {
        if cards.count == 0 {
            return nil
        } else {
            let card = cards.removeFirst()
            cardsOnBoard.append(card)
            return card
        }
    }
    
    mutating func choseCard(card: SetCard) {
        misMatchedSetCards.removeAll()
        if cardsSelectd.count == 3 {
            cardsSelectd.removeAll()
        }
        
        if cardsSelectd.contains(card) {
            cardsSelectd.remove(at: cardsSelectd.index(of: card)!)
            score -= 1
            return
        }
        
        cardsSelectd.append(card)
        if cardsSelectd.count == 3 {
            if makeASet (selectedCards: cardsSelectd) {
                matchedSets += 1
                cardsMatched += cardsSelectd
                cardsOnBoard = cardsOnBoard.filter { !cardsSelectd.contains($0) }
                score += 3
            } else {
                misMatchedSetCards += cardsSelectd
                score -= 5
            }
        }
    }
    
    func makeASet(selectedCards cards: [SetCard]) -> Bool {
        // look at each attribute. It must be all different or all the same
        // so, if you find 2 of any attribute, it's not a set
        
        var colors = [SetCard.Color: Bool]()
        var shapes = [SetCard.Shape: Bool]()
        var numbers = [SetCard.Number: Bool]()
        var shading = [SetCard.Shading: Bool]()
        
        for card in cards {
            colors[card.color] = true
            shapes[card.shape] = true
            numbers[card.number] = true
            shading[card.shading] = true
        }
        
        
        if colors.count == 2 {
            //
            return false
        }
        if shapes.count == 2 {
            //
            return false
        }
        if numbers.count == 2 {
            //
            return false
        }
        if shading.count == 2 {
            //
            return false
        }
        return true
    }
}

extension Array {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Dictionary {
    func keysAsStringList() -> String {
        var keys = [String]()
        for key in self.keys {
            let s = "\(key)"
            keys.append(s)
        }
        return keys.joined(separator: ",")
    }
}
