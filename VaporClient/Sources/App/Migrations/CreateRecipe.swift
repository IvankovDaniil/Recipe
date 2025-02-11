//
//  CreateRecipe.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 24.01.2025.
//
import Fluent

struct CreateRecipe: Migration {
    func prepare(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("recipes")
            .id()
            .field("title", .string, .required)
            .field("steps", .string, .required)
            .field("ingredients", .string, .required)
            .field("image", .string, .required)
            .field("rating", .double, .required)
            .create()
    }
    
    func revert(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("recipes").delete()
    }
}
