//
//  LoginView.swift
//  Recipe
//
//  Created by Даниил Иваньков on 30.01.2025.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(UserViewModel.self) private var userViewModel
    @State var email: String = ""
    @State var password: String = ""
    let action: () -> Void
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10){

                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    if userViewModel.errorMessage != nil {
                        Text(userViewModel.errorMessage!)
                            .foregroundColor(.red)
                    }
                    Button {
                        Task {
                            try await userViewModel.loginUser(email, password)
                        }
                        action()
                    } label: {
                        Text("Войти")
                            .padding(15)
                            .blueRoundedBorder()
                    }
                    .disabled(userViewModel.isLoad)

                }
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .padding()
            }
            .onChange(of: userViewModel.isRegistred, {
                action()
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        action()
                    } label: {
                        Text("Закрыть")
                    }

                }
            }
            .navigationTitle("Вход")
            
        }
    }
}

#Preview {
    LoginView(action: {})
        .modelContainer(for: UserModel.self, inMemory: true)
        .environment(UserViewModel(modelContext: ModelContext.preview))
}
