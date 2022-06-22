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
    private(set) var timeLastCardWasChosen = Date()
    var score : Int = 0
    
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
        let currentTime = Date()
        let timeSpent = Int(currentTime.timeIntervalSince(timeLastCardWasChosen))
        verifyIfSetWasCards(time: timeSpent) { (playedSeconds) in
            return 2 * max(30 - playedSeconds, 1)
        }
        if let index = dealedCards.firstIndex(matching: card) {
            dealedCards[index].isSelected.toggle()
        }
        timeLastCardWasChosen = currentTime
        checkIfCardsMatch()
    }
    
    private mutating func verifyIfSetWasCards(time: Int, calculate: (Int) -> Int) {
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            for selectedCard in selectedCards {
                if let index = dealedCards.firstIndex(matching: selectedCard) {
                    if GameViewModel.gameMatchState == .cardsAreMatched {
                        score += calculate(time)
                        removeAndReplaceCards(index)
                    } else {
                        dealedCards[index].isSelected.toggle()
                        score -= calculate(time)
                    }
                }
            }
        }
    }
    
    mutating func dealCards() {
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            for selectedCard in selectedCards {
                if let index = dealedCards.firstIndex(matching: selectedCard) {
                    if GameViewModel.gameMatchState == .cardsAreMatched {
                        removeAndReplaceCards(index)
                    }
                    else if GameViewModel.gameMatchState == .notSet || GameViewModel.gameMatchState == .cardsAreNotMatched {
                          
                    }
                }
            }
        }
    }

    private mutating func removeAndReplaceCards(_ index: Int) {
        dealedCards.remove(at: index)
        if let newCard = deck.drawCard() {
            dealedCards.insert(newCard, at: index)
        }
    }
    
    private func checkIfCardsMatch() {
        GameViewModel.gameMatchState = .notSet
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            let cardNumbers = Int(selectedCards[0].number.rawValue + selectedCards[1].number.rawValue + selectedCards[2].number.rawValue)
            let cardShapes = Int(selectedCards[0].shape.rawValue + selectedCards[1].shape.rawValue + selectedCards[2].shape.rawValue)
            let cardShadings = Int(selectedCards[0].shading.rawValue + selectedCards[1].shading.rawValue + selectedCards[2].shading.rawValue)
            let cardColors = Int(selectedCards[0].color.rawValue + selectedCards[1].color.rawValue + selectedCards[2].color.rawValue)
            if (cardNumbers + cardShapes + cardShadings + cardColors) % 3 == 0 {
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

