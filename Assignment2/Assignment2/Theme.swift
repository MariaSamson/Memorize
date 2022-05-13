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
    var numberOfCards: Int?
    var color: String
    
    init(themeName: String, themeEmoji: [String],themeColor: String) {
        self.name=themeName
        self.emoji=themeEmoji
        self.color=themeColor
    }
    
    init(name: String, emoji: [String], numberOfCards: Int, color: String) {
        self.name=name
        self.emoji=emoji
        self.numberOfCards=numberOfCards > emoji.count ? emoji.count : numberOfCards
        self.color=color
    }

}
