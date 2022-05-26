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
        Text("\(game.statusText)")
        Text("Score: \(game.score)")
        Spacer()
        newGameCards
        AspectGrid(items: game.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
                .padding(13)
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
        dealCards
        .disabled(game.cardsRemaining == 0)
      }
    }
   
    func newGame() {
         self.game.newGame()
    }
    
    func dealMoreCards() {
        self.game.drawCard(3)
    }
    
    var dealCards: some View {
         VStack{
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

