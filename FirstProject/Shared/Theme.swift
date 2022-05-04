//
//  Theme.swift
//  FirstProject
//
//  Created by Samson Maria Andreea on 03.05.2022.
//

import Foundation
struct Theme{
    var emoji:[String]

    static let themes = [
        Theme(emoji:["🤩","😍","🥳","😅","🤓","😎","😚","😏"]),
        Theme(emoji: ["💀","👻","🎃","🤡","👽","🤖", "👾","🧛‍♀️"]),
        Theme(emoji: ["🇦🇩","🇺🇸","🏳","🇹🇩","🇻🇳","🏳️‍🌈","🏳️‍⚧️","🇺🇳"])]

    static func randomTheme() -> Theme {
            return themes[Int.random(in: 0..<themes.count)]
        }
}
