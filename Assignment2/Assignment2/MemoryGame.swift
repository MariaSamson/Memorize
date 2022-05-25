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
