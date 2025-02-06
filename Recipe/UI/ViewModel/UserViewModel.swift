//
//  UserViewModel.swift
//  Recipe
//
//  Created by Даниил Иваньков on 29.01.2025.
//

import SwiftUI
import SwiftData

@Observable
class UserViewModel  {
    let vaporClient = VaporClient()
    var isLoad = false
    var errorMessage: String?
    var isRegistred: Bool = false
    var user: UserModel? = nil
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadUser()
    }

    
    var nameError = false
    var surnameError = false
    var emailError = false
    var passwordError = false
    
    //На старте приложения проверяем есть ли пользователь залогиненный
    func loadUser() {
        let fetchDescriptor = FetchDescriptor<UserModel>()
        if let savedUser = try? modelContext.fetch(fetchDescriptor).first {
            self.user = savedUser
        }
    }
    //Проверяем отсутсвуют ли пустые филды при заполнение формы реги
    func checkIsEmpty(_ name: String,_ surname: String, _ email: String, _ password: String) -> Bool {
        nameError = name.isEmpty
        surnameError = surname.isEmpty
        emailError = email.isEmpty
        passwordError = password.isEmpty
        
        return !nameError && !surnameError && !emailError && !passwordError
    }
    //Регистрация
    func registerUser(_ name: String,_ surname: String, _ email: String, _ password: String) async throws {
        guard checkIsEmpty(name, surname, email, password) else {
            return
        }
        
        isLoad = true
        errorMessage = nil
        do {
            let userResponse = try await vaporClient.register(name: name, surname: surname, password: password, email: email)
            isRegistred = true
            let newUser = UserModel(id: userResponse.id, name: userResponse.name, password: userResponse.password, surname: userResponse.surname, email: userResponse.email)
            modelContext.insert(newUser)
            try modelContext.save()
            user = newUser
        } catch {
            errorMessage = "Регистрация провалена: \(error)"
        }
        
        isLoad = false
    }
    
    func loginUser(_ email: String, _ password: String) async throws {
        isLoad = true
        
        errorMessage = nil
        do {
            let userResponse = try await vaporClient.login(email: email, password: password)
            let newUser = UserModel(id: userResponse.id, name: userResponse.name, password: userResponse.password, surname: userResponse.surname, email: userResponse.email)
            modelContext.insert(newUser)
            try modelContext.save()
            self.user = newUser
        } catch {
            errorMessage = "Ошибка при входе"
        }
        
        isLoad = false
    }
    
    //Разлогиниться
    func logout() {
        if let user = user {
            modelContext.delete(user)
            do {
                try modelContext.save()
            } catch {
                
            }
            self.user = nil
        }
        
    }
}

private struct UserViewModelKey: EnvironmentKey {
    static var defaultValue: UserViewModel? = nil
}

extension EnvironmentValues {
    var userViewModel: UserViewModel? {
        get { self[UserViewModelKey.self] }   // ✅ Используем правильный ключ!
        set { self[UserViewModelKey.self] = newValue }
    }
}
