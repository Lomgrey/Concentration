//
//  Concentration.swift
//  Concentration
//
//  Created by Sergey Lomakin on 28/12/2018.
//  Copyright © 2018 Sergey Lomakin. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get {
            var foundIndex : Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    private(set) var score = 0
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): inndex is out of bounds crds array")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    score += 2
                } else if cards[index].seen {
                    score -= 1
                }
                cards[index].seen = true
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
        }
    }
    
    func resetGame() {
        for i in 0...cards.count - 1 {
            cards[i].seen = false
            cards[i].isMatched = false
            cards[i].isFaceUp = false
        }
        score = 0
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0,
               "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
}
