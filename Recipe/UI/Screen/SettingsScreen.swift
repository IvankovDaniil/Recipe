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
    @State private var isPresented: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Вы не авторизованы")
            Text("Для того, что бы у вас была возможность отмечать рецепты и получать информацию на почту, зарегистрируйтесь")
                .padding([.top, .bottom], 15)
                .multilineTextAlignment(.center)
            
            Button {
                isPresented = true
            } label: {
                Text("Регистрация")
                    .padding(15)
                    .blueRoundedBorder()
            }
            .sheet(isPresented: $isPresented, content: {
                RegisterView(action: { isPresented = false })
            })
            

        }
        .padding()
    }
}

private struct RegisterView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isValid: Bool = true
    
    let action: () -> Void
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 0) {
                    TextField("Введите имя", text: $name)
                        .padding(.top, 15)
                    TextField("Введите фамилию", text: $surname)
                        .padding(.top, 15)
                    TextField("Введите электронную почту", text: $email)
                        .keyboardType(.emailAddress)
                        .border(.clear)
                        .padding(.top, 15)
                    SecureField("Введите пароль", text: $password)
                        .padding(.top, 15)
                    
                    Button {
                        //
                    } label: {
                        Text("Регистрация")
                            .padding(15)
                            .blueRoundedBorder()
                    }
                    .padding(.top, 20)
                }
                .autocorrectionDisabled(true)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .padding(15)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            action()
                        } label: {
                            Text("Закрыть")
                        }

                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            action()
                        } label: {
                            Text("Сохранить")
                        }

                    }
                }
                .navigationTitle("Регистрация")
            }
        }
        
    }
}

#Preview {
    SettingsScreen()
}

