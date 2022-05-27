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
    private(set) var timeLastThreeCardsWereChosen = Date()
    var score : Int = 0
    let maxNumberOfSeconds: Int = 30
    
    var cardsRemainingInDeck: Int {
        deck.countRemainingCards
    }
    
    mutating func addCard() -> Card? {
        guard let card = deck.drawCard() else {
            print("No more cards")
            return nil
        }
        dealedCards.append(card)
        return card
    }
    
    mutating func choose(_ card: Card) {
        let timeWhenNewSetWasFound = Date()
        let timeSpent = Int(timeWhenNewSetWasFound.timeIntervalSince(timeLastThreeCardsWereChosen))
        replaceCards(card, time: timeSpent)
        timeLastThreeCardsWereChosen = timeWhenNewSetWasFound
        checkIfCardsMatch()
    }
    
    private mutating func replaceCards(_ card: Card, time: Int) {
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            for card in selectedCards {
                if let index = dealedCards.firstIndex(matching: card) {
                    if GameViewModel.gameMatchState == .cardsAreMatched {
                        score += calculateNewScore(time)
                        dealedCards.remove(at: index)
                        if let newCard = deck.drawCard() {
                            dealedCards.insert(newCard, at: index)
                        }
                    } else {
                        dealedCards[index].isSelected.toggle()
                        score -= calculateNewScore(time)
                    }
                }
            }
        }
        if let index = dealedCards.firstIndex(matching: card) {
            dealedCards[index].isSelected.toggle()
        }
    }
    
    private func calculateNewScore(_ playedSeconds : Int) -> Int {
        2 * max(maxNumberOfSeconds - playedSeconds, 1)
    }
    
    private func checkIfCardsMatch() {
        GameViewModel.gameMatchState = .notSet
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            let numbers = Int(selectedCards[0].number.rawValue + selectedCards[1].number.rawValue + selectedCards[2].number.rawValue)
            let shapes = Int(selectedCards[0].shape.rawValue + selectedCards[1].shape.rawValue + selectedCards[2].shape.rawValue)
            let shadings = Int(selectedCards[0].shading.rawValue + selectedCards[1].shading.rawValue + selectedCards[2].shading.rawValue)
            let colorss = Int(selectedCards[0].color.rawValue + selectedCards[1].color.rawValue + selectedCards[2].color.rawValue)
            if (numbers + shapes + shadings + colorss) % 3 == 0 {
                GameViewModel.gameMatchState = .cardsAreMatched
            } else {
            GameViewModel.gameMatchState = .cardsAreNotMatched
        }
    }
}

    enum Number: Int, CaseIterable, Hashable {
        case one = 1, two, three
    }

    enum Color: Int, CaseIterable, Hashable {
        case blue = 1, purple = 2, green = 3
    }

    enum Shading: Int, CaseIterable, Hashable {
        case solid = 1, stripped = 2, outlined = 3
    }

    enum Shape: Int, CaseIterable, Hashable {
        case circle , squiggle, diamond
        var description: Int {
            switch self {
                case .circle:
                    return 1
                case .squiggle:
                    return 2
                case .diamond:
                    return 3
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
