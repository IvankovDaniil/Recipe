//
//  File.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 26.01.2025.
//

import Foundation
import Vapor
import Fluent

public final class RecipeController: RouteCollection, Sendable {
    public func boot(routes: any Vapor.RoutesBuilder) throws {
        let recipe = routes.grouped("recipes")
        recipe.get(use: getAllRecipes)
        recipe.post(use: addNewRecipe)
    }
    
    @Sendable
    func getAllRecipes(_ req: Request) throws -> EventLoopFuture<[Recipe]> {
        Recipe.query(on: req.db).all()
    }
    
    @Sendable
    func addNewRecipe(_ req: Request) async throws -> Recipe {
        do {
            // 1. Декодируем объект из запроса
            let newRecipe = try req.content.decode(Recipe.self)
            
            // 2. Загружаем картинку
            do {
                let imageUrl = try await getRecipeImage(req: req, query: newRecipe.title)
                newRecipe.image = imageUrl
            } catch {
                req.logger.error("Ошибка загрузки фото: \(error)")
                throw Abort(.notFound, reason: "Image not found")
            }
            
            // 3. Сохраняем в базу данных
            try await newRecipe.save(on: req.db)
            return newRecipe
        } catch let error as DecodingError {
            req.logger.error("Ошибка парсинга JSON: \(error)")
            throw Abort(.badRequest, reason: "Invalid JSON format")
        } catch {
            req.logger.error("Ошибка сохранения рецепта: \(error)")
            throw Abort(.internalServerError)
        }
    }
    
    func getRecipeImage(req: Request, query: String) async throws -> String {
        let unisplashURL = "https://api.unsplash.com/search/photos?query=\(query)&client_id=aQJcPbzFcYsV_hNHB2_nEe8anQ-s9fvCmHploZg7zBA"
        
        let response = try await req.client.get(URI(string: unisplashURL))
        let unisplashData = try response.content.decode(UnisplashResponse.self)
        
        if unisplashData.results.count >= 3 {
            return unisplashData.results[2].urls.regular
        } else if unisplashData.results.count >= 2 {
            return unisplashData.results[1].urls.regular
        } else if let imageUrl = unisplashData.results.first?.urls.regular {
            return imageUrl
        } else {
            throw Abort(.notFound, reason: "No suitable images found for query \(query)")
        }
        
        
    }
}


struct UnisplashResponse: Content {
    let results: [UnisplashImage]
}

struct UnisplashImage: Content {
    let urls: ImageURLs
}

struct ImageURLs: Content {
    let regular: String
}
