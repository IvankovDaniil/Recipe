//
//  UserViewModel.swift
//  Recipe
//
//  Created by Даниил Иваньков on 29.01.2025.
//

import SwiftUI

@Observable
class UserViewModel  {
    let vaporClient = VaporClient()
    var isLoad = false
    var errorMessage: String?
    var isRegistred: Bool = false
    
    func registerUser(_ name: String,_ surname: String, _ email: String, _ password: String) async throws {
        isLoad = true
        errorMessage = nil
        do {
            let _ = try await vaporClient.register(name: name, surname: surname, password: password, email: email)
            isRegistred = true
        } catch {
            errorMessage = "Регистрация провалена: \(error)"
        }
        
        isLoad = false
    }
}
