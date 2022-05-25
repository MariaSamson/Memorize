//
//  EmojiMemoryGame.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {

    var theme: Theme

    init() {
        theme = EmojiMemoryGame.themes.randomElement()!
        theme.emoji.removeDuplicates()
        theme.emoji.shuffle()
        
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static var themes: [Theme] = [
          Theme(name: "Flags", emoji: ["🇺🇸","🏳","🇹🇩","🏳️‍🌈","🇺🇳","🇨🇦","🇪🇺","🇮🇹"], color: "blue", numberOfPairsCards: 4),
          Theme(name: "Faces", emoji: ["🤩","😍","🥳","😅","🤓","😎","😚","😏","😇"], color: "black", numberOfPairsCards: 5),
          Theme(name: "Animals", emoji: ["🐶","🐻","🐝","🦊","🐥","🐷","🐬","🐙","🐸"], color: "mint", numberOfPairsCards: 6),
          Theme(name: "Fruits", emoji: ["🍏","🍎","🍋","🍉","🥥","🥝","🍒"], color: "pink"),
          Theme(name: "Cars", emoji: ["🚗","🚗","🚙","🚙"], color: "green", numberOfPairsCards: 2),
          Theme(name: "Travel", emoji: ["✈️","🏝","🌇","🚢","🏙"], color: "gray", numberOfPairsCards: 8)]
  
    var themeColorForCards: Color {
        if theme.color == "blue" {
            return .blue
        }
        else if theme.color == "black" {
            return .black
        }
        else if theme.color == "mint" {
            return .mint
        }
        else if theme.color == "pink" {
            return Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
        }
        else if theme.color == "gray" {
            return .gray
        }
        else {
            return .green
        }
    }
        
    var cardsName: String {
        return theme.name
    }

    var scoreCards: Int {
        return model.score
    }
    
    //EXTRA CREDIT
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        var numberOfPairsOfCards = theme.numberOfPairsCards
//          MemoryGame<String>(numberOfPairsOfCards: theme.numberOfCards) {
//              pairIndex in
//          return theme.emoji[pairIndex]
        if theme.name == "Flags" || theme.name == "Travel" {
            numberOfPairsOfCards = Int.random(in: 4...theme.emoji.count)
        }
        return MemoryGame(numberOfPairsOfCards: numberOfPairsOfCards ?? theme.emoji.count){ theme.emoji[$0]
        }
   }
    
    @Published private var model: MemoryGame<String>
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card)
    {
        objectWillChange.send()
        model.choose(card)
    }
    
    func beginNewGame()
    {
        theme = EmojiMemoryGame.themes.randomElement()!
        theme.emoji.removeDuplicates()
        theme.emoji.shuffle()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
