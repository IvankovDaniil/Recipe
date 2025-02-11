//
//  UserController.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 24.01.2025.
//
import Fluent
import Vapor
import Foundation


public final class UserController: RouteCollection, Sendable {
    public func boot(routes: any Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: getAllUsers)
        users.post("register", use: registerUser)
        users.post("login", use: login)
        
    }
    @Sendable
    func getAllUsers(_ req: Request) throws -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    @Sendable
    func login(_ req: Request) throws -> EventLoopFuture<User> {
        let credentials = try req.content.decode(LoginCredential.self)
        
        return User.query(on: req.db)
            .filter(\.$email == credentials.email)
            .first()
            .flatMap { user in
                guard let user = user else {
                    return req.eventLoop.makeFailedFuture(Abort(.notFound))
                }
                
                if user.password == credentials.password {
                    return req.eventLoop.makeSucceededFuture(user)
                } else {
                    return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
                }
            }
    }
    
    @Sendable
    func registerUser(_ req: Request) throws -> EventLoopFuture<User> {
        let newUser = try req.content.decode(User.self)
    
        
        return User.query(on: req.db)
            .filter(\.$email == newUser.email)
            .first()
            .flatMap { user in
                if user != nil  {
                    return req.eventLoop.makeFailedFuture(Abort(.conflict, reason: "Email is already in use"))
                }
                
                return newUser.save(on: req.db).map{ newUser }
            }
    }
}

struct LoginCredential: Content {
    let email: String
    let password: String
}
