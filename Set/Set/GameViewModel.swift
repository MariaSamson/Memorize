//
//  GameViewModel.swift
//  Set
//
//  Created by Samson Maria Andreea on 17.05.2022.
//

import Foundation

class GameViewModel: ObservableObject {
    
    @Published var model = Game()
    static var gameMatchState: StateOfCards = .notSet
    
    
    var cards: [Game.Card] {
        return model.dealedCards
    }

    func drawCard(_ number: Int) {
        for _ in 0..<number {
            _ = model.addCard()
        }
    }

    func newGame() {
        model = Game()
        drawCard(12)
    }
    
    func choose(_ card: Game.Card) {
        model.choose(card)
    }
    
    func dealMoreCards() {
        drawCard(3)
    }
    
    var statusText: String {
        switch GameViewModel.gameMatchState {
        case .cardsAreMatched:
            return "Is a match"
        case .cardsAreNotMatched:
            return "Is not a match"
        default:
            return "Just choose 3 cards"
    }
  }
    
    enum StateOfCards {
        case cardsAreMatched
        case cardsAreNotMatched
        case notSet
    }
}