//
//  MemoryGame.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    var value: Int = 0
    private var indexOfTheOneAndOnlyDFaceUpCard: Int?
    var lastTimeCardsMatch = Date()
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched
           {
            let currentDataTime = Date()
            if let potentialMatchIndex = indexOfTheOneAndOnlyDFaceUpCard {
                cards[chosenIndex].seen += 1
                cards[potentialMatchIndex].seen += 1
                if  cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
          //        score += 2
                    value = Int(currentDataTime.distance(to: lastTimeCardsMatch))
                    score += max(Int(10 - value), 1)*2
                    lastTimeCardsMatch = Date()
                }
                else {
                    if cards[chosenIndex].seen > 1 {
        //              score -= 1
                        value = Int(currentDataTime.distance(to: lastTimeCardsMatch))
                        score += max(Int(10 - value), 1)*(-1)
                    }
                    if cards[potentialMatchIndex].seen > 1 {
          //            score -= 1
                        value = Int(currentDataTime.distance(to: lastTimeCardsMatch))
                        score += max(Int(10 - value), 1)*(-1)
                    }

                }
            indexOfTheOneAndOnlyDFaceUpCard = nil
            }
            else{
                 for index in cards.indices {
                     if cards[index].isFaceUp == true {
                        cards[index].isFaceUp = false
                     }
                  }
                indexOfTheOneAndOnlyDFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        //add numberOfPairsOfCard x 2 cards to cards array

        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var seen: Int = 0
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        // can be zero which means "no bonus points" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever face up
        private var faceUptime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - pastFaceUpTime)
        }

        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }

        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUptime
            lastFaceUpDate = nil
        }
    }

}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
