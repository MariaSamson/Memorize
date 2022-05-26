//
//  CardView.swift
//  Set
//
//  Created by Samson Maria Andreea on 17.05.2022.
//

import Foundation
import SwiftUI

struct Diamond:Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // get the center of the rect
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // get the starting of our drawing the right side of our diamond
        let startingPoint = CGPoint(x: rect.maxX, y: center.y)
        // move our start of drawing to the beggining point
        path.move(to: startingPoint)
        // distance / 2 is our height
        // create all our points
        let secondPoint = CGPoint(x: center.x, y: rect.maxY)
        let thirdPoint = CGPoint(x: rect.minX , y: center.y)
        let fourthPoint = CGPoint(x: center.x, y: rect.minY)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.addLine(to: fourthPoint)
        path.addLine(to: startingPoint)
        return path
    }
}

struct CardView: View {
    var card: Game.Card
    //var isMismatched: Bool = true

    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 4

    var body: some View {
        GeometryReader { (proxy) in
            self.body(for: proxy.size)
        }
    }

    func body(for size: CGSize) -> some View {
        let symbolCount = card.number.rawValue
       
        return ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)

                VStack {
                    ForEach(0..<symbolCount,id: \.self) { _ in
                        self.symbol
                    }
                }
                .padding(10)
            }
        }
        .foregroundColor(cardColor)
        .scaleEffect(card.isSelected ? 1.2 : 1) //zoom when touch the card
    }

    var symbol: some View {
        Group {
            if card.shape == .diamond {
                if card.shading == .outlined {
                    Diamond().stroke(lineWidth: 3)
                }
                else if card.shading == .solid {
                    Diamond().fill()
                }
                else {
                    ZStack{
                        Stripe(width: Int(1.0)).stroke(lineWidth: 1.0).mask( Diamond().fill())
                        Diamond().stroke()
                    }
                }
            }
            if card.shape == .oval {
                if card.shading == .outlined {
                    Circle().stroke(lineWidth: 3)
                }
                else if card.shading == .solid {
                    Circle().fill()
                }
                else {
                    ZStack{
                        Stripe(width: Int(1.0)).stroke(lineWidth: 1.0).mask( Circle().fill())
                        Circle().stroke()
                    }
                }
            }
            if card.shape == .rectangle {
                if card.shading == .outlined {
                    Squiggle().stroke(lineWidth: 3)
                }
                else if card.shading == .solid {
                    Squiggle().fill()
                }
                else {
                    ZStack{
                        Stripe(width: Int(1.0)).stroke(lineWidth: 1.0).mask( Squiggle().fill())
                        Squiggle().stroke()
                    }
                }
            }
        }
    }

    var cardColor: Color {
        switch card.color {
            case .blue:
                return Color.blue
            case .purple:
                return Color.purple
            case .green:
                return Color.green
        }
    }
}
