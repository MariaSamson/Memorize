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
        
    init(){
        theme = EmojiMemoryGame.themes.randomElement()!
        theme.emoji.shuffle()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static var themes : [Theme] = [
        Theme(name: "Flags", emoji: ["🇦🇩","🇺🇸","🏳","🇹🇩","🇻🇳","🏳️‍🌈","🏳️‍⚧️","🇺🇳","🇨🇦","🇪🇺","🇮🇹"], numberOfCards: 4, color: "blue"),
          Theme(name: "Faces", emoji: ["🤩","😍","🥳","😅","🤓","😎","😚","😏","😇","🤫","🫠"], numberOfCards: 4, color: "black"),
          Theme(name: "Animals", emoji: ["🐶","🐻","🐝","🦊","🐥","🐷","🐒","🐠","🐬","🐙","🐸"], numberOfCards: 6, color: "mint"),
          Theme(name: "Fruits", emoji: ["🍏","🍎","🍋","🍉","🥥","🥝","🍒"], numberOfCards: 8, color: "pink"),
          Theme(name: "Cars", emoji: ["🚗","🚙","🚑"], numberOfCards: 8, color: "green"),
          Theme(name: "Travel", emoji: ["✈️","🏝","🌇","🚢","🏙"], numberOfCards: 8, color: "gray")]
  
    var themeColorForCards: Color{
        if theme.color == "blue"{
            return .blue
        }
        else if theme.color == "black"{
            return .black
        }
        else if theme.color == "mint"{
            return .mint
        }
        else if theme.color == "pink"{
            return .pink
        }
        else if theme.color == "gray"{
            return .gray
        }
        else{
            return .green
        }
    }
        
    var cardsName: String{
        return theme.name
    }

    var scoreCards : Int{
        return model.score
    }
    
    static func createMemoryGame(theme: Theme) ->MemoryGame<String>{
          MemoryGame<String>(numberOfPairsOfCards: theme.numberOfCards) { pairIndex in
               return theme.emoji[pairIndex]
        }
    }
    
    
    @Published private var model: MemoryGame<String>
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    //MARK - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card)
    {
        objectWillChange.send()
        model.choose(card)
    }
    
    func beginNewGame()
    {
        theme = EmojiMemoryGame.themes.randomElement()!
        theme.emoji.shuffle()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    

}
