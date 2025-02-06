//
//  SettingsFlow.swift
//  Recipe
//
//  Created by Даниил Иваньков on 21.01.2025.
//

import SwiftUI

struct SettingsFlow: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        SettingsScreen()
    }
}

#Preview {
    SettingsFlow()
}
