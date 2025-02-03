//
//  VaporClient.swift
//  Recipe
//
//  Created by Даниил Иваньков on 29.01.2025.
//
import Foundation

class VaporClient {
    private let baseURL = "http://127.0.0.1:8080"
    
    func sendRequest<T: Codable, U: Codable>(to endpoint: String,
                                                method: String,
                                                body: T? = nil,
                                                responseType: U.Type) async throws -> U {
        
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            fatalError("Invalid URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(responseType, from: data)
    }
    
    func sendGetRequest<U: Codable>(to endpoint: String,
                                                method: String,
                                                responseType: U.Type) async throws -> U {
        
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            fatalError("Invalid URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(responseType, from: data)
    }
}



extension VaporClient {
    func register(name: String, surname: String, password: String, email: String) async throws -> RegisterResponse {
        let req = RegisterRequest(name: name, surname: surname, password: password, email: email)
        
        do {
            return try await sendRequest(
                to: "/users/register",
                method: "POST",
                body: req,
                responseType: RegisterResponse.self)
        } catch {
            if let httpError = error as? HTTPURLResponse, httpError.statusCode == 409 {
                throw NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "This email is already in use"])
            }
            throw error
        }
    }
    
    func login(email: String, password: String) async throws -> RegisterResponse {
        let req = LoginResponse(email: email, password: password)
        
        do {
            return try await sendRequest(to: "/users/login",
                                         method: "POST",
                                         body: req,
                                         responseType: RegisterResponse.self)
        } catch {
            if let httpError = error as? HTTPURLResponse, httpError.statusCode == 404 {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Не правильная почта или пароль"])
            }
            throw error

        }
    }
    
    func getAllRecipe() async throws -> [RecipeDTO] {
        do {
            return try await sendGetRequest(to: "/recipes", method: "GET", responseType: [RecipeDTO].self)
        } catch {
            throw error
        }
    }
}
