//
//  CreateFavouriteRecipe.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 24.01.2025.
//
import Fluent

struct CreateFavouriteRecipe: Migration {
    func prepare(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("favorite_recipes")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("recipe_id", .uuid, .required, .references("recipes", "id", onDelete: .cascade))
            .unique(on: "user_id", "recipe_id") // Пользователь может добавить каждый рецепт в избранное только один раз
            .create()

    }
    
    func revert(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("favorite_recipes").delete()
    }
}
