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
    var numberOfPairsCards: Int?
    var color: String
    
    init(themeName: String, themeEmoji: [String],themeColor: String) {
        self.name = themeName
        self.emoji = themeEmoji
        self.color = themeColor
    }
    
    init(name: String, emoji: [String], color: String, numberOfPairsCards: Int) {
        self.name = name
        self.emoji = emoji
        self.numberOfPairsCards = numberOfPairsCards > emoji.count ? emoji.count : numberOfPairsCards
        self.color = color
    }

}
