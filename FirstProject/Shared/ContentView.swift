//
//  ContentView.swift
//  Shared
//
//  Created by Samson Maria Andreea on 02.05.2022.
//

import SwiftUI

struct ContentView: View {
    @State var emojis = ["🤩","😍","🥳","😅","🤓","😎","😚","😏","😇","🤫","🫠"]
    
    var faces = ["🤩","😍","🥳","😅","🤓","😎","😚","😏","😇","🤫","🫠"]
    var animals = ["🐶","🐻","🐝","🦊","🐥","🐷","🐒","🐠","🐬","🐙","🐸"]
    var flags = ["🇦🇩","🇺🇸","🏳","🇹🇩","🇻🇳","🏳️‍🌈","🏳️‍⚧️","🇺🇳","🇨🇦","🇪🇺","🇮🇹"]
    
    //EXTRA CREDIT - 1.
    @State var emojiCount = Int.random(in: 4...11)
    
    func widthThatBestFits(cardCount: Int) -> CGFloat{
        switch cardCount {
            case 4:
                return 110
            case 5...9:
                return 80
            case 10...14:
                return 68
            default:
                return 65
            }
     }
    var body: some View {
        VStack{
            Text("Memorize!").font(.largeTitle)
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: emojiCount)))]) {
                ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                      CardView(content: emoji).aspectRatio(2/3,contentMode: .fit)
                  }
            }
        }
       .foregroundColor(.red)
       Spacer()
          HStack(spacing: 60){
          facesTheme
          animalsTheme
          flagTheme
         }
       .font(.subheadline)
       .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    var facesTheme: some View{
        VStack{
            Button {
                emojiCount=RandomCard()
                emojis = faces.shuffled()
             }
        label:{
            VStack{
              Image(systemName: "face.smiling").font(.largeTitle)
              Text("Vehicles")
            }
        }
        }}

    
    var animalsTheme: some View{
      VStack{
          Button {
              emojiCount=RandomCard()
              emojis = animals.shuffled()
          } label: {
            VStack{
              Image(systemName: "pawprint").font(.largeTitle)
              Text("Animals")
            }
        }
      }
    }
    
    
    var flagTheme: some View{
      VStack{
        Button {
            emojiCount=RandomCard()
            emojis = flags.shuffled()
        } label: {
            VStack{
                Image(systemName: "flag").font(.largeTitle)
                Text("Flags")
            }
        }
      }
   }
    
    func RandomCard() -> Int{
        Int.random(in: 4...9)
    }
}

struct CardView: View{
    var content : String
    @State var isFaceUp : Bool = true
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
          if isFaceUp {
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: 3)
            Text(content).font(.largeTitle)
          }else
            {
              shape.fill()
          }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}
struct ContentView_Preview: PreviewProvider{
    static var previews: some View{
        ContentView()
            .preferredColorScheme(.light)
    }
}

