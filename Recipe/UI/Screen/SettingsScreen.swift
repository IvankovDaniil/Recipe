//
//  SettingsScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 21.01.2025.
//

import SwiftUI
import SwiftData

struct SettingsScreen: View {
    @Environment(\.viewModel) var viewModel: RecipeViewModel?
    
    var body: some View {
        HStack(spacing: 0) {
            if let user = viewModel?.user {
                Text("Hello \(user.name)")
            } else {
                NonRegisterView()
            }
        }
    }
}

private struct NonRegisterView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Вы не авторизованы")
            Text("Для того, что бы у вас была возможность отмечать рецепты и получать информацию на почту, зарегистрируйтесь")
                .padding([.top, .bottom], 15)
            
            Button {
                isPresented = true
            } label: {
                Text("Регистрация")
                    .padding(15)
                    .blueRoundedBorder()
            }
            .sheet(isPresented: $isPresented, content: {
                RegisterView()
            })
            

        }
        .padding()
    }
}

private struct RegisterView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("REEEGEEGEG")
        }
    }
}

#Preview {
    SettingsScreen()
}

