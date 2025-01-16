//
//  ReciptFlow.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import SwiftUI

struct ReciptFlow: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationStack {
            ReciptScreen(modelContext: modelContext)
        }
    }
}

#Preview {
    ReciptFlow()
}
