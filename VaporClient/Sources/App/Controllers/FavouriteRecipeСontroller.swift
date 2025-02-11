//
//  Untitled.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 27.01.2025.
//
import Foundation
import Vapor
import Fluent

final class FavouriteRecipeController: RouteCollection, Sendable {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let favRecipe = routes.grouped("favRecipe")
        favRecipe.post("user", use: addNewFavoriteRecipe)
        favRecipe.get("user" , ":user_id", use: getUserFavRecipes)
        favRecipe.delete("user", ":user_id", ":recipe_id", use: removeFromFavorite)
    }
    
    @Sendable
    func addNewFavoriteRecipe(_ req: Request) throws -> EventLoopFuture<FavRecipe> {
        let data = try req.content.decode(FavRecipeData.self)
        
        let favRecipe = FavRecipe(userID: data.userID, recipeID: data.recipeID)

        return FavRecipe.query(on: req.db)
            .filter(\FavRecipe.$user.$id == data.userID)
            .filter(\FavRecipe.$recipe.$id == data.recipeID)
            .first()
            .flatMap { isfavRecipe in
                if isfavRecipe != nil {
                    return req.eventLoop.makeFailedFuture(Abort(.imUsed, reason: "recipe is already in fav"))
                }
                
                return favRecipe.save(on: req.db).map { favRecipe }
            }
    }
    
    @Sendable
    func getUserFavRecipes(_ req: Request) throws -> EventLoopFuture<[FavRecipe]> {
        let userID = try req.parameters.require("user_id", as: UUID.self)
        
        return FavRecipe.query(on: req.db)
            .filter(\FavRecipe.$user.$id == userID)
            .with(\FavRecipe.$recipe)
            .all()
    }
    
    @Sendable
    func removeFromFavorite(_ req: Request) throws -> EventLoopFuture<Response> {
        let userID = try req.parameters.require("user_id", as: UUID.self)
        let recipeID = try req.parameters.require("recipe_id", as: UUID.self)
        
        return FavRecipe.query(on: req.db)
            .filter(\FavRecipe.$user.$id == userID)
            .filter(\FavRecipe.$recipe.$id == recipeID)
            .first()
            .flatMap { favRecipe in
                guard let favRecipe = favRecipe else {
                    return req.eventLoop.makeFailedFuture(Abort(.badRequest))
                }
                
                return favRecipe.delete(on: req.db).transform(to: Response(status: .ok))
            }
    
    }
    
}


private struct FavRecipeData: Content {
    var userID: UUID
    var recipeID: UUID
}
