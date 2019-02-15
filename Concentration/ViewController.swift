//
//  ViewController.swift
//  Concentration
//
//  Created by Sergey Lomakin on 28/12/2018.
//  Copyright © 2018 Sergey Lomakin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    var score = 0 {
        didSet {
            flipCountLabel.text = "Score: \(score)"
        }
    }
    
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        score += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
        score = game.score
    }
    
//    var emojiChoiser = ["🤨", "🧐", "👻", "🎃", "🍭", "🍬", "🍫", "🍪", "🍎"]
    var emojiChoiser = ["🤨", "🧐", "👻", "🎃", "🍭", "🍬"]
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoiser.count > 0 {
            let randomIndex = arc4random_uniform(UInt32(emojiChoiser.count))
            emoji[card.identifier] = emojiChoiser.remove(at: Int(randomIndex))
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func newGameActon(_ sender: UIButton) {

        game.resetGame()
        score = 0
        updateViewFromModel()
        
    }
}

