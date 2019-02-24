//
//  ViewController.swift
//  Concentration
//
//  Created by Sergey Lomakin on 28/12/2018.
//  Copyright © 2018 Sergey Lomakin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairOfCards)
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLable()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var numberOfPairOfCards : Int {
        return cardButtons.count / 2
    }
    
    private(set) var score = 0 {
        didSet {
            updateScoreLable()
        }
    }
    
    private func updateScoreLable() {
        let attributes : [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initThemes()
        setRandomTheme()
        
    }
    
    private var themesDictionary = [Int: Theme]()
    
    private func initThemes() {
        themesDictionary[0] = Theme(emojiSequence: ["🤨", "🧐", "👻", "🎃", "🍭", "🍬", "🍎", "🍪"])
        themesDictionary[1] = Theme(emojiSequence: ["⚽️", "🏀", "🏈", "🚴🏻‍♀️", "🤽🏻‍♂️", "🎻", "🎹", "🏊🏼‍♂️"])
        themesDictionary[2] = Theme(emojiSequence: ["🐶", "🐸", "🐵", "🐔", "🐷", "🦄", "🦅", "🦞"])
        themesDictionary[3] = Theme(emojiSequence: ["📱", "💻", "🖥", "📺", "🧭", "⌚️", "💿", "📽"])
        themesDictionary[4] = Theme(emojiSequence: ["🚠", "✈️", "🛩", "🚊", "🏍", "🚐", "🚜", "🛸"])
        themesDictionary[5] = Theme(emojiSequence: ["🥺", "🤥", "🙂", "🙃", "🤫", "😲", "🧐", "🤐"])
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        score += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel(){
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
    
    
    private var emojiChoiser = [String]()
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoiser.count > 0 {
            let randomIndex = Int.random(in: 0...emojiChoiser.count - 1)
            emoji[card] = emojiChoiser.remove(at: randomIndex)
        }
        
        return emoji[card] ?? "?"
    }
    
    @IBAction private func newGameActon(_ sender: UIButton) {

        score = 0
        game.resetGame()
        emoji.removeAll()
        setRandomTheme()
        updateViewFromModel()
    }
    
    private func setRandomTheme() {
        let randIndex = Int.random(in: 0...themesDictionary.count - 1)
        setTheme(theme: themesDictionary[randIndex] ?? themesDictionary[0]!)
    }
    
    private func setTheme(theme: Theme) {
        emojiChoiser = theme.emojiChoiser
    }
}

