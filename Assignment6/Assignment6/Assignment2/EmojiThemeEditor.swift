//
//  EmojiThemeEditor.swift
//  Assignment2
//
//  Created by Samson Maria Andreea on 10.06.2022.
//

import SwiftUI

struct EmojiThemeEditor: View {
    
    @Binding var emojiTheme: Theme
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(emojiTheme.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $emojiTheme.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            emojiTheme.emoji = (emojis + emojiTheme.emoji)
                .filter { $0.isEmoji }
        }
    }
    
    var removeEmojiSection: some View {
        Section {
            let emojis = emojiTheme.emoji
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojiTheme.emoji.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                emojiTheme.emoji.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        EmojiThemeEditor(emojiTheme: .constant(StoreTheme(name: "Preview").thm[0]))
    }
}
