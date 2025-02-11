//
//  File.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 24.01.2025.
//

import Foundation
import Fluent
import Vapor

final class FavRecipe: Content, Model, @unchecked Sendable {
    static let schema: String = "favorite_recipes"
    init(){}
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "recipe_id")
    var recipe: Recipe
    
    init(id: UUID? = nil, userID: UUID, recipeID: UUID) {
        self.id = id
        self.$recipe.id = recipeID
        self.$user.id = userID 
    }
}
