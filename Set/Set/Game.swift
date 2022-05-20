//
//  Game.swift
//  Set
//
//  Created by Samson Maria Andreea on 16.05.2022.
//

import Foundation
import SwiftUI

struct Game {
    
    private(set) var deck = Deck()
    private(set) var dealedCards: [Card] = []
   
    var cardsRemainingInDeck: Int {
        deck.countRemainingCards
    }
    
    mutating func addCard() -> Card? {
        guard let card = deck.drawCard() else {
            print("no more cards in deck")
            return nil
        }
        dealedCards.append(card)
        return card
    }
    
    mutating func choose(_ card: Card){
        
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
             _ = checkIfCardsMatch()
            // Replace matched cards with new ones
            for card in selectedCards {
                let index = dealedCards.firstIndex(matching: card)
                if GameViewModel.gameMatchState == .cardsAreMatched {
                    dealedCards.remove(at: index!)
                    if let newCard = deck.drawCard() {
                        dealedCards.insert(newCard, at: index!)
                    }
                } else {
                    dealedCards[index!].isSelected.toggle()
                }
            }
        }

        let index = dealedCards.firstIndex(matching: card)
        dealedCards[index ?? 0].isSelected.toggle()
    }
    
    mutating func checkIfCardsMatch() -> Bool {
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            if selectedCards[0].number == selectedCards[1].number && selectedCards[1].number == selectedCards[2].number &&
                selectedCards[0].shape.rawValue != selectedCards[1].shape.rawValue && selectedCards[1].shape.rawValue != selectedCards[2].shape.rawValue &&
                selectedCards[0].color.rawValue == selectedCards[1].color.rawValue && selectedCards[1].color.rawValue == selectedCards[2].color.rawValue &&
                selectedCards[0].shading.rawValue == selectedCards[1].shading.rawValue && selectedCards[1].shading.rawValue == selectedCards[2].shading.rawValue {
                GameViewModel.gameMatchState = .cardsAreMatched
              return true
            } else if selectedCards[0].number != selectedCards[1].number && selectedCards[1].number != selectedCards[2].number &&
                    selectedCards[0].shape.rawValue == selectedCards[1].shape.rawValue && selectedCards[1].shape.rawValue == selectedCards[2].shape.rawValue &&
                    selectedCards[0].color.rawValue == selectedCards[1].color.rawValue && selectedCards[1].color.rawValue == selectedCards[2].color.rawValue &&
                    selectedCards[0].shading.rawValue == selectedCards[1].shading.rawValue && selectedCards[1].shading.rawValue == selectedCards[2].shading.rawValue {
                    GameViewModel.gameMatchState = .cardsAreMatched
                  return true
            } else if selectedCards[0].number == selectedCards[1].number && selectedCards[1].number == selectedCards[2].number &&
                    selectedCards[0].shape.rawValue == selectedCards[1].shape.rawValue && selectedCards[1].shape.rawValue == selectedCards[2].shape.rawValue &&
                    selectedCards[0].color.rawValue != selectedCards[1].color.rawValue && selectedCards[1].color.rawValue != selectedCards[2].color.rawValue &&
                    selectedCards[0].shading.rawValue == selectedCards[1].shading.rawValue && selectedCards[1].shading.rawValue == selectedCards[2].shading.rawValue {
                    GameViewModel.gameMatchState = .cardsAreMatched
                  return true
            } else if selectedCards[0].number == selectedCards[1].number && selectedCards[1].number == selectedCards[2].number &&
                    selectedCards[0].shape.rawValue == selectedCards[1].shape.rawValue && selectedCards[1].shape.rawValue == selectedCards[2].shape.rawValue &&
                    selectedCards[0].color.rawValue == selectedCards[1].color.rawValue && selectedCards[1].color.rawValue == selectedCards[2].color.rawValue &&
                    selectedCards[0].shading.rawValue != selectedCards[1].shading.rawValue && selectedCards[1].shading.rawValue != selectedCards[2].shading.rawValue {
                    GameViewModel.gameMatchState = .cardsAreMatched
                  return true
                }
            else {
                GameViewModel.gameMatchState = .cardsAreNotMatched
            }
        }
        
        return false
    }
    
    
    enum Number: Int, CaseIterable, Hashable {
        case one = 1, two, three
    }

    enum Color: String, CaseIterable, Hashable {
        case blue = "blue", purple = "purple", green = "green"
    }

    enum Shading: String, CaseIterable, Hashable {
        case solid, stripped, outlined
    }

    enum Shape: String, CaseIterable, Hashable, CustomStringConvertible {
        case oval , rectangle, diamond

        var description: String {
            switch self {
                case .oval:
                    return "O"
                case .rectangle:
                    return "▭"
                case .diamond:
                    return "◇"
            }
        }
    }
    
    struct Card: Identifiable {
        var id : Int
        var number: Number
        var color: Color
        var shape: Shape
        var shading: Shading
        
        var isFaceUp = true
        var isSelected : Bool = false
  
    }

  struct Deck {
        private var cards: [Card] = []
        
        init() {
            for number in Number.allCases {
                for color in Color.allCases {
                    for shape in Shape.allCases {
                        for shading in Shading.allCases {
                            cards.append(Card(id: cards.count,number: number, color: color, shape: shape, shading: shading))
                        }
                    }
                }
            }
            cards.shuffle()
        }

        mutating func drawCard() -> Card? {
            guard cards.count > 0 else {
                return nil
            }
            return cards.removeFirst()
        }
      
       var countRemainingCards: Int {
           cards.count
       }
    }
}


extension Array where Element: Identifiable {
    func firstIndex(matching item: Element) -> Int? {
        if let index = self.firstIndex(where: {item.id == $0.id}) {
            return index
        }
        return nil
    }
}
