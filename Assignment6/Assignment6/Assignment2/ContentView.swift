//
//  ContentView.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    @State var theme: Theme?
    
    var body: some View {
     VStack{
        Text("\(viewModel.cardsName)")
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card, gradient: Gradient(colors: [self.viewModel.themeColorForCards, .pink]))
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
        // newTheme
        .font(.subheadline)
        .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var newTheme: some View {
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

struct CardView: View {
    let card: MemoryGame<String>.Card
    let gradient: Gradient
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    // function @ViewBuilder to handle if / else case
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                        .onAppear {
                            self.startBonusAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.scale)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    // Need to check whether card.isMatched as Animation is reused
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
       }
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize)-> CGFloat {
        min(size.width, size.height ) * 0.7
    }
}

struct ContentView_Preview: PreviewProvider{
    static var previews: some View{
        let game = EmojiMemoryGame(theme: StoreTheme(name: "Preview").thm[0])
        game.choose(game.cards.first!)
        return ContentView(viewModel: game)
    }
}

