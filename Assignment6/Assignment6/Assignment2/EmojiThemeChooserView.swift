//
//  EmojiThemeChooser.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 09.06.2022.
//

import SwiftUI


struct EmojiThemeChooserView: View {

    @EnvironmentObject var store: StoreTheme
    @State private var editMode: EditMode = .inactive
    @State private var editTheme: Theme?
    //UUID A universally unique value to identify types, interfaces, and other items.
    @State var games: [UUID: EmojiMemoryGame] = [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.thm) { theme in
                    if let game = game(for: theme) {
                       EmojiThemeRow(game: game, theme: theme)
                            .gesture(editMode == .active ? tapGestureOnTheme(on: theme) : nil)
                    }
                }
                .onDelete { indexSet in
                    store.thm.remove(atOffsets: indexSet)
                  }
                .onMove { store.thm.move(fromOffsets: $0, toOffset: $1) }
                .gesture(editMode == .active ? tap : nil)
                
            }
            .navigationTitle("Memorize")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    addButton
                }
            }

            .sheet(item: $editTheme) {
                editMode = .inactive
            } content: { theme in
                EmojiThemeEditor(emojiTheme: $store.thm[theme])
                    .onChange(of: store.thm[theme]) { newTheme in
                        games[theme.id] = EmojiMemoryGame(theme: newTheme)
                    }
            }
            .environment(\.editMode, $editMode)
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        
    }
    
    func tapGestureOnTheme(on theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            editTheme = theme
        }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
    
    var addButton: some View {
        Button(action: { store.thm.append(Theme(name: "Cars", emoji: "🚗🚕🚙🚌🚎", color: "blue", numberOfPairsCards: 4)) },
               label: { Image(systemName: "plus").imageScale(.large) })
        .opacity(editMode == .inactive ? 1 : 0)
    }
    
    func game(for theme: Theme) -> EmojiMemoryGame? {
        if games[theme.id] == nil {
            games[theme.id] = EmojiMemoryGame(theme: theme)
        }
        return games[theme.id]
    }
}
    
    struct EmojiThemeRow: View {
        @ObservedObject var game: EmojiMemoryGame
        var theme: Theme
        var emojiCount: Int { theme.emoji.count }

        
        var body: some View {
            NavigationLink {
                ContentView(viewModel: game)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(theme.name)
                            .font(.title2)
                            .foregroundColor(game.themeColorForCards)
                            .bold()
                            .font(.largeTitle)
                    }
                    .padding([.trailing], 3)
                    Text(theme.emoji.description)
                    Spacer()
                    HStack {
                        Text("Number of cards in game: \(emojiCount)")
                    }
                }
                .font(.title2)
            }
        }
    }

    
    struct EmojiThemeChooserView_Preview: PreviewProvider{
        static var previews: some View {
            let store = StoreTheme(name: "Preview")
            EmojiThemeChooserView()
                .environmentObject(store)
        }
    }
