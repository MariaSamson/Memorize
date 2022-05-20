//
//  SetApp.swift
//  Set
//
//  Created by Samson Maria Andreea on 16.05.2022.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(game: GameViewModel())
        }
    }
}
