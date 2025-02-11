//
//  SettingsScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 21.01.2025.
//

import SwiftUI
import SwiftData

struct SettingsScreen: View {
    @Environment(UserViewModel.self) private var userViewModel
    
    
    var body: some View {
        HStack(spacing: 0) {
            if let user = userViewModel.user {
                UserAuthorized(user: user) {
                    userViewModel.logout()
                }
            } else {
                NonRegisterView()
            }
        }
    }
}

private struct NonRegisterView: View {
    @State private var isRegPresented: Bool = false
    @State private var isLoginPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Вы не авторизованы")
            Text("Для того, что бы у вас была возможность отмечать рецепты и получать информацию на почту, зарегистрируйтесь")
                .padding([.top, .bottom], 15)
                .multilineTextAlignment(.center)
            
            HStack {
                Button {
                    isRegPresented = true
                } label: {
                    Text("Регистрация")
                        .padding(15)
                        .blueRoundedBorder()
                }
                .sheet(isPresented: $isRegPresented, content: {
                    RegisterView(action: { isRegPresented = false })
                })
                
                Button {
                    isLoginPresented = true
                } label: {
                    Text("Войти")
                        .padding(15)
                        .blueRoundedBorder()
                }
                .sheet(isPresented: $isLoginPresented, content: {
                    LoginView(action: { isLoginPresented = false })
                })
            }
        }
        .padding()
    }
}


#Preview {
    SettingsScreen()
        .modelContainer(for: UserModel.self, inMemory: true)
        .environment(UserViewModel(modelContext: ModelContext.preview))
}

