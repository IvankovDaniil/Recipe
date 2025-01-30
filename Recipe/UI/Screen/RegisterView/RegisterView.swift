//
//  RegisterView.swift
//  Recipe
//
//  Created by Даниил Иваньков on 29.01.2025.
//
import SwiftUI
import SwiftData

struct RegisterView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var password: String = ""
    @State private var email: String = ""

    @Environment(UserViewModel.self) private var userViewModel
    
    let action: () -> Void
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        
                        TextField("Введите имя", text: $name)
                            .border(userViewModel.nameError ? Color.red : Color.gray)
                            .padding(.top, 15)
                        TextField("Введите фамилию", text: $surname)
                            .border(userViewModel.surnameError ? Color.red : Color.gray)
                            .padding(.top, 15)
                        TextField("Введите электронную почту", text: $email)
                            .keyboardType(.emailAddress)
                            .border(userViewModel.emailError ? Color.red : Color.gray)
                            .padding(.top, 15)
                        SecureField("Введите пароль", text: $password)
                            .border(userViewModel.passwordError ? Color.red : Color.gray)
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
                        }
                        
                    } label: {
                        Text("Регистрация")
                            .padding(15)
                            .blueRoundedBorder()
                    }
                    .padding(.top, 20)
                    .disabled(userViewModel.isLoad)
                    
                }
                .onChange(of: userViewModel.isRegistred, {
                    action()
                })
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
                }
                .navigationTitle("Регистрация")
            }
        }
        
    }
}


#Preview {
    RegisterView(action: {})
        .modelContainer(for: UserModel.self, inMemory: true) // 👈 Добавляем контейнер для Preview
        .environment(UserViewModel(modelContext: ModelContext.preview))
    
}


extension ModelContext {
    /// Фейковый `modelContext` для Preview
    static var preview: ModelContext {
        let container = try! ModelContainer(for: UserModel.self, configurations: .init(isStoredInMemoryOnly: true))
        return ModelContext(container)
    }
}
