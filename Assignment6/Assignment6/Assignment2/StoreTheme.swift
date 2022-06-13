//
//  StoreTheme.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 10.06.2022.
//

import Foundation

class StoreTheme: ObservableObject {
    private var name: String
    
    @Published var thm: [Theme] = [] {
        didSet {
            storeInUserDefaults()
        }
    }
    
    init(name: String) {
        self.name = name
       // restoreFromUserDefaults()
        if thm.isEmpty {
            thm.append(Theme(name: "Cars", emoji: "🚗🚕🚙🚌🚎", color: "blue", numberOfPairsCards: 4))
            thm.append(Theme(name: "Faces", emoji: "🤩😍🥳😅🤓😎😚😏😇", color: "black", numberOfPairsCards: 5))
            thm.append(Theme(name: "Sport", emoji: "⚽️🏀🏈⚾️🥎🎾", color: "mint", numberOfPairsCards: 6))
            thm.append(Theme(name: "Fruits", emoji: "🍏🍎🍋🍉🥥🥝🍒", color: "pink",numberOfPairsCards: 10))
            thm.append(Theme(name: "Travel", emoji: "✈️🏝🌇🚢🏙", color: "gray", numberOfPairsCards: 8))
            
        }
    }
    
    private var userDefaultsKey: String {
        "StoreTheme:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(thm), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            thm = decodedThemes
        }
    }
}
