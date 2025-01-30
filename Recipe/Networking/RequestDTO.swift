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
