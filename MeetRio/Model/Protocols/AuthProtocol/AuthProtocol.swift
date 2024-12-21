//
//  AuthProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseAuth

protocol AuthProtocol: FirebaseAuthProtocol {}

protocol FirebaseAuthProtocol {
    
    static var loggedCase: LoginCase { get set }
    
    static func getAuthenticatedUser() throws -> User

    // Login methods
    static func signIn(email: String, password: String) async throws -> User
    static func signOut() async throws
    static func signInAnonymous() async throws -> User
    func resetPassword(email: String) async throws
    
    // Account Manager
    static func createAccount(email: String, password: String) async throws -> User
    mutating func deleteAccount() async throws
}

// MARK: GetAuthenticated Methods
extension FirebaseAuthProtocol {
    
    static func getAuthenticatedUser() throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noUserAuthenticated
        }
        return user
    }
    
}

// MARK: Login Methods
extension FirebaseAuthProtocol {
    
    static func signIn(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        Self.loggedCase = .registered
        return authDataResult.user
    }
    
    static func signOut() async throws { // TODO: Verificar como vamos fazer para notificar a view de que o user fez o signOut
        try Auth.auth().signOut()
        Self.loggedCase = .none
    }
    
    static func signInAnonymous() async throws -> User {
        let authDataResult = try await Auth.auth().signInAnonymously()
        Self.loggedCase = .anonymous
        return authDataResult.user
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

// MARK: Account Manager
extension FirebaseAuthProtocol {
    
    static func createAccount(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        Self.loggedCase = .registered
        return authDataResult.user
    }
    
    // TODO: Integrar esse método aos outros métodos de deletar (Precisamos deletar também o perfil de hóspede/hostel desse user, se user é hospede, deletar seus ImGoing, e deletar suas fotos do CloudStorage)
    mutating func deleteAccount() async throws { // TODO: Mudar a visibilidade da função
        let user = try Self.getAuthenticatedUser()
        try await user.delete()
        Self.loggedCase = .none
    }
    
}
