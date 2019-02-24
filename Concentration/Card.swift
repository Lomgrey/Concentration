//
//  Card.swift
//  Concentration
//
//  Created by Sergey Lomakin on 28/12/2018.
//  Copyright © 2018 Sergey Lomakin. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int { return identifier}
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier: Int
    
    var seen = false
    var isFaceUp = false
    var isMatched = false
    
    private static var idetifierFactory = 0
    
    private static func getUnicIdentifire() -> Int {
        Card.idetifierFactory += 1
        return idetifierFactory
    }
    
    init() {
        self.identifier = Card.getUnicIdentifire()
    }
}
