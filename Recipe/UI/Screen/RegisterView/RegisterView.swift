//
//  RegisterView.swift
//  Recipe
//
//  Created by Даниил Иваньков on 29.01.2025.
//
import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    let userViewModel = UserViewModel()
    
    let action: () -> Void
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 0) {
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
                    }
                    .autocorrectionDisabled()
                    
                    if let errorMessage = userViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .lineLimit(3)
                    }
                    
                    Button {
                        Task {
                            try await userViewModel.registerUser(name, surname, email, password)
                            action()
                        }
                    } label: {
                        Text("Регистрация")
                            .padding(15)
                            .blueRoundedBorder()
                    }
                    .padding(.top, 20)
                    .disabled(userViewModel.isLoad)
                    
                    if userViewModel.isRegistred {
                        Text("Registration successful! 🎉")
                            .foregroundColor(.green)
                    }
                    
                }
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
    RegisterView(action: {})
}
