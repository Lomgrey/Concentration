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
    
    let numberOfButtons = 16
    var cardButtons = [UIButton]()
    
    var screenWidth: Int {
        return Int(UIScreen.main.bounds.width)
    }
    
    var screenHeight: Int {
        return Int(UIScreen.main.bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillCardButtons()
        initThemes()
        setRandomTheme()
        
    }
    
    var themesDictionary = [Int: Theme]()
    
    func initThemes() {
        themesDictionary[0] = Theme(emojiSequence: ["🤨", "🧐", "👻", "🎃", "🍭", "🍬", "🍎", "🍪"])
        themesDictionary[1] = Theme(emojiSequence: ["⚽️", "🏀", "🏈", "🚴🏻‍♀️", "🤽🏻‍♂️", "🎻", "🎹", "🏊🏼‍♂️"])
        themesDictionary[2] = Theme(emojiSequence: ["🐶", "🐸", "🐵", "🐔", "🐷", "🦄", "🦅", "🦞"])
        themesDictionary[3] = Theme(emojiSequence: ["📱", "💻", "🖥", "📺", "🧭", "⌚️", "💿", "📽"])
        themesDictionary[4] = Theme(emojiSequence: ["🚠", "✈️", "🛩", "🚊", "🏍", "🚐", "🚜", "🛸"])
        themesDictionary[5] = Theme(emojiSequence: ["🥺", "🤥", "🙂", "🙃", "🤫", "😲", "🧐", "🤐"])
    }
    
    func fillCardButtons() {
        let numberOfCountCardsInRow = 4
        
        let indent = 20 // right and left
        let upIndent = 80
        let xSpacingBetweenCards = 10
        let ySpacingBetweenCards = 20
        
        let availableWidthForCards = (screenWidth - indent * 2 - xSpacingBetweenCards * (numberOfCountCardsInRow - 1))
        
        let widthOfCard = availableWidthForCards / numberOfCountCardsInRow
        let heightOfCard = Int(Double(widthOfCard) * 1.3)
        
        var row = 0
        var cardInRow = 0
        while cardButtons.count < numberOfButtons {
            let x = indent + cardInRow * widthOfCard + cardInRow * xSpacingBetweenCards
            let y = upIndent + row * heightOfCard + row * ySpacingBetweenCards
            
            let card = getNewCardButton(xPositom: x, yPosition: y, width: widthOfCard, height: heightOfCard)
            cardButtons.append(card)
            
            if cardInRow == numberOfCountCardsInRow - 1 {
                row += 1
                cardInRow = 0
            } else {
                cardInRow += 1
            }
        }
    }
    
    func getNewCardButton(xPositom x: Int, yPosition y: Int, width: Int, height: Int) -> UIButton {
        let card = UIButton(type: UIButton.ButtonType.system) as UIButton
        
        card.frame = CGRect(x: x, y: y, width: width, height: height)
        card.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        card.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        card.addTarget(self, action: #selector(ViewController.touchCard(_:)), for: .touchUpInside)
        
        self.view.addSubview(card)
        
        return card
    }
    
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
    
    var emojiChoiser = [String]()
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
        emoji.removeAll()
        setRandomTheme()
        score = 0
        updateViewFromModel()
        
    }
    
    func setRandomTheme() {
        let randIndex = Int.random(in: 0...themesDictionary.count - 1)
        setTheme(theme: themesDictionary[randIndex] ?? themesDictionary[0]!)
    }
    
    func setTheme(theme: Theme) {
        emojiChoiser = theme.emojiChoiser
    }
}

