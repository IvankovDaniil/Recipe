//
//  BackgroundStyle.swift
//  Recipe
//
//  Created by Даниил Иваньков on 17.01.2025.
//

import Foundation
import SwiftUI

struct BackgroundStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background (
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.blue, lineWidth: 4)
                    .shadow(color: .blue, radius: 5, x: 3, y: 3)
        )
    }
}

extension View {
    
    func blueRoundedBorder() -> some View {
        self.modifier(BackgroundStyle())
    }
}
