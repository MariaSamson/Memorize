//
//  Assignment2App.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 05.05.2022.
//

import SwiftUI

@main
struct Assignment2App: App {
    
    @StateObject private var themeStore = StoreTheme(name: "Default")
    
    var body: some Scene {
        WindowGroup {
            EmojiThemeChooserView().environmentObject(themeStore)
        }
    }
}
