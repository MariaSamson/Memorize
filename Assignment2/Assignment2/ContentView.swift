//
//  ContentView.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    @State var theme: Theme
    
    var body: some View {
     VStack{
        Text("\(viewModel.cardsName)")
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.cards) { card in
                      CardView(card: card)
                        .aspectRatio(2/3,contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                  }
           }
        }
         
        .foregroundColor(viewModel.themeColorForCards)
         Text("Score is: \(viewModel.scoreCards)")
         Spacer()
         newTheme
        .font(.subheadline)
        .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var newTheme: some View{
          VStack{
              Button {
                  viewModel.beginNewGame()
              } label: {
                VStack{
                  Text("New Theme")
                  
                }
            }
          }
        }
}

struct CardView: View{
    let card: MemoryGame<String>.Card
    
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: 3)
            Text(card.content).font(.largeTitle)
            }else if card.isMatched{
                shape.opacity(0)
            }else {
              shape.fill()
          }
        }
    }
}
struct ContentView_Preview: PreviewProvider{
    static var previews: some View{
        let game = EmojiMemoryGame()
        ContentView(viewModel: game, theme: EmojiMemoryGame.themes.randomElement()!)
            .preferredColorScheme(.light)
    }
}

