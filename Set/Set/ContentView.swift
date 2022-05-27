//
//  ContentView.swift
//  Set
//
//  Created by Samson Maria Andreea on 16.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var game = GameViewModel()
    @Namespace private var dealingNamespace
    @Namespace var discardSpace
    
    var body: some View {
      VStack {
        Text("\(game.statusText)")
        Spacer()
        AspectGrid(items: game.cards, aspectRatio: 2/3) { card in
            CardView(card: card,isUndealt: false)
                .padding(5)
                .animation(.linear(duration: 1), value: 1.0)
                .rotationEffect(Angle.degrees(GameViewModel.gameMatchState == .cardsAreMatched ? 360 : 0))
                .rotationEffect(Angle.degrees(GameViewModel.gameMatchState == .cardsAreNotMatched ? 5 : 0))
                .onTapGesture {
                    withAnimation {
                        getPiledCards()
                        game.choose(card)
                    }
                }
                
         }
          HStack {
              Spacer()
              deckBody
              Spacer()
              discardPileBody
              Spacer()
          }
          HStack {
              Spacer()
              newGameCards
              Spacer()
          }
          
        .onAppear {
            self.newGame()
        }
      }
        .foregroundColor(.blue)
    }
    
    private func isUndealt(_ card: Game.Card) -> Bool {
        return game.cards.contains(card)
    }
    
    private func zIndex(of card: Game.Card) -> Double {
        -Double(game.allCards.firstIndex(of: card) ?? 0)
    }
    
    @State var matchedCards = [Game.Card]()
    
    private func getPiledCards() {
        if GameViewModel.gameMatchState == .cardsAreMatched {
          for card in game.allCards {
              //var dup = card
             // dup.isMatched = false
              if !matchedCards.contains(card) {
                  matchedCards.append(card)
              }
          }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card,isUndealt: true)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            withAnimation {
               getPiledCards()
            }
            withAnimation(.linear(duration: 0.3).delay(0.25)) {
                game.dealMoreCards()
            }
        }
    }
    
    var discardPileBody: some View {
        return ZStack {
            Color.clear
            ForEach(game.discardedCards) { card in
                CardView(card: card,isUndealt: false)
                    .matchedGeometryEffect(id: card.id, in: discardSpace)
            }
        }
        .frame(width: 60, height: 90)
    }
    
    func newGame() {
         self.game.newGame()
    }
    
    func dealMoreCards() {
        self.game.drawCard(3)
    }
    
    var restart: some View {
        Button("Restart") {
        }
    }
   
    var dealCards: some View {
         VStack{
            Button {
                withAnimation(.linear(duration: 0.3).delay(0.25)) {
                    game.dealMoreCards()
                }
             } label: {
             VStack {
                Text("Deal with 3 cards")
             }
           }
       }
    }
    
    var newGameCards: some View {
        VStack{
            Button {
                game.newGame()
            } label: {
            VStack {
               Text("New Game")
                   }
             }
          }
     }
}
