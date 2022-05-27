//
//  ContentView.swift
//  Set
//
//  Created by Samson Maria Andreea on 16.05.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game = GameViewModel()

    var body: some View {
      VStack {
          HStack {
            Spacer()
            Text("\(game.statusText)")
            Spacer()
            Text("Score: \(game.score)")
            Spacer()
          }
        newGameCards
        AspectGrid(items: game.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
                .padding(5)
                .animation(.linear(duration: 1), value: 1.0)
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        }
        .onAppear {
            self.newGame()
        }
        HStack {
            Spacer()
            dealCards
            .disabled(game.cardsRemaining == 0)
            Spacer()
        }
      }
    }
   
    func newGame() {
         self.game.newGame()
    }
    
    func dealMoreCards() {
        self.game.drawCard(3)
    }
    
    var dealCards: some View {
         VStack {
            Button {
                game.dealMoreCards()
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
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

