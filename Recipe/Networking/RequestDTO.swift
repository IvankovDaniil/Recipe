//
//  RequestDTO.swift
//  Recipe
//
//  Created by Даниил Иваньков on 30.01.2025.
//
import Foundation

struct RegisterRequest: Codable {
    let name: String
    let surname: String
    let password: String
    let email: String
}

struct RegisterResponse: Codable {
    let id: UUID
    let name: String
    let surname: String
    let password: String
    let email: String
}

struct LoginResponse: Codable {
    let email: String
    let password: String
}


struct RecipeDTO: Codable {
    let id: UUID
    let title: String
    let image: String
    let steps: String
    let ingredients: String
    let rating: Double
}

extension RecipeDTO {
    func decodeJSON(recipeElement: String) -> [String] {
        let data = Data(base64Encoded: recipeElement) ?? Data()
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}
