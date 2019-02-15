//
//  Card.swift
//  Concentration
//
//  Created by Sergey Lomakin on 28/12/2018.
//  Copyright © 2018 Sergey Lomakin. All rights reserved.
//

import Foundation

struct Card {
    var isWatched = false
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var idetifierFactory = 0
    
    static func getUnicIdentifire() -> Int {
        Card.idetifierFactory += 1
        return idetifierFactory
    }
    
    init() {
        self.identifier = Card.getUnicIdentifire()
    }
}
