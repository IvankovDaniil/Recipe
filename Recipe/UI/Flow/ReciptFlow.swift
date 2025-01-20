//
//  ReciptFlow.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import SwiftUI

struct ReciptFlow: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Recipe]()
    
    var body: some View {
        NavigationStack(path: $path) {
            ReciptScreen(path: $path, modelContext: modelContext, screenCondition: .recipeScreen)
        }
    }
}

#Preview {
    ReciptFlow()
}
