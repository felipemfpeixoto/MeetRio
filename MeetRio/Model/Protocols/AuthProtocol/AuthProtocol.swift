//
//  AuthProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseAuth

protocol AuthProtocol {
    static func getAuthenticatedUserID() throws -> String

    // Login methods
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    func signInAnonymous() async throws -> User
    func resetPassword(email: String) async throws
    
    // Account Manager
    func createAccount() async throws
    func deleteAccount(email: String, password: String) async throws
}

// MARK: GetAuthenticated Methods
extension AuthProtocol {
    
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
extension AuthProtocol {
    
    func signIn(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authDataResult.user
    }
    
    func signOut() async throws { // TODO: Verificar como vamos fazer para notificar a view de que o user fez o signOut
        try Auth.auth().signOut()
    }
    
    func signInAnonymous() async throws -> User {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return authDataResult.user
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

// MARK: Account Manager
extension AuthProtocol {
    
    func createAccount(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    // TODO: Integrar esse método aos outros métodos de deletar (Precisamos deletar também o perfil de hóspede/hostel desse user, se user é hospede, deletar seus ImGoing, e deletar suas fotos do CloudStorage)
    func deleteAccount(_ willDeleteAll: Bool = true) async throws {
        let user = try Self.getAuthenticatedUser()
        try await user.delete()
    }
    
}
