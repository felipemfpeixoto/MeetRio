//
//  UserProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserProtocol: Codable, CRUDItem, AuthProtocol {
    
    var name: String { get set }
    var email: String { get set }
    var imageURL: String? { get set }
    
    static func getUserHospede() async throws -> Self
    mutating func deleteUser() async throws
    
    init(user: User)
}

extension UserProtocol {
    
    init(isAnonymous: Bool = false) async throws {
        if !isAnonymous {
            self = try await Self.getUserHospede()
        } else {
            let anonymousUser = try await Self.signInAnonymous()
            self = Hospede(user: anonymousUser) as! Self // TODO: Atualmente estamos instânciando diretamente como Hospede, mas futuramente o user poderá ser um Hostel ou Admin
        }
    }
    
    init(email: String, password: String, isNewUser: Bool = false) async throws {
        if !isNewUser {
            let signInUser = try await Self.signIn(email: email, password: password)
            let id = signInUser.uid
            self = try await Self.getItem(for: id)
        } else {
            let newUser = try await Self.createAccount(email: email, password: password)

            self = Self.init(user: newUser) // MARK: Self.init pois não estamos instânciando apenas Hospedes, mas também Hostels
        }
    }
}

extension UserProtocol {
    
    static func getUserHospede() async throws -> Self {
        let user = try self.getAuthenticatedUser()
        if user.isAnonymous {
            Self.loggedCase = .anonymous
            return Self.init(user: user)
        }
        Self.loggedCase = .registered
        return try await self.getItem(for: user.uid)
    }
    
    mutating func deleteUser() async throws { // TODO: Precisamos ter um método dentro do fornecedor que, após a exclusão ter sido completada, seta o valor de User para nil
        try await self.deleteItem()
        try await self.deleteAccount()
        try await Self.signOut()
    }
    
}
