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
    
    var loggedCase: LoginCase { get set }
    
    static func getAuthenticatedUser() throws -> User
    static func getAuthenticatedUserID() throws -> String

    // Login methods
    static func signIn(email: String, password: String) async throws -> User
    mutating func signOut() async throws
    mutating func signInAnonymous() async throws -> User
    func resetPassword(email: String) async throws
    
    // Account Manager
    mutating func createAccount(email: String, password: String) async throws
    mutating func deleteAccount(_ willDeleteAll: Bool) async throws
}

// MARK: GetAuthenticated Methods
extension FirebaseAuthProtocol {
    
    static func getAuthenticatedUser() throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noUserAuthenticated
        }
        return user
    }
    
    static func getAuthenticatedUserID() throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noUserAuthenticated_id
        }
        return user.uid
    }
    
}

// MARK: Login Methods
extension FirebaseAuthProtocol {
    
    static func signIn(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
//        Self.loggedCase = .registered
        return authDataResult.user
    }
    
    mutating func signOut() async throws { // TODO: Verificar como vamos fazer para notificar a view de que o user fez o signOut
        try Auth.auth().signOut()
        self.loggedCase = .none
    }
    
    mutating func signInAnonymous() async throws -> User {
        let authDataResult = try await Auth.auth().signInAnonymously()
        self.loggedCase = .anonymous
        return authDataResult.user
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

// MARK: Account Manager
extension FirebaseAuthProtocol {
    
    mutating func createAccount(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
        self.loggedCase = .registered
    }
    
    // TODO: Integrar esse método aos outros métodos de deletar (Precisamos deletar também o perfil de hóspede/hostel desse user, se user é hospede, deletar seus ImGoing, e deletar suas fotos do CloudStorage)
    mutating func deleteAccount(_ willDeleteAll: Bool = true) async throws {
        let user = try Self.getAuthenticatedUser()
        try await user.delete()
        self.loggedCase = .none
    }
    
}
