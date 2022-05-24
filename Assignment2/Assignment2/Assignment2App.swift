//
//  Assignment2App.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import SwiftUI

@main
struct Assignment2App: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game, theme: EmojiMemoryGame.themes.randomElement()!)
        }
    }
}