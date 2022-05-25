//
//  Theme.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import Foundation
import SwiftUI


struct Theme {
    
    var name: String
    var emoji: [String]
    var color: String
    var numberOfPairsCards: Int?
    
    init(name: String, emoji: [String], color: String) {
        self.name = name
        self.emoji = emoji
        self.color = color
    }
    
    init(name: String, emoji: [String], color: String, numberOfPairsCards: Int) {
        self.name = name
        self.emoji = emoji
        self.numberOfPairsCards = numberOfPairsCards > emoji.count ? emoji.count : numberOfPairsCards
        self.color = color
    }
}
