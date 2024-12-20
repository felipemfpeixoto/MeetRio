//
//  UserProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseFirestore

protocol UserProtocol: Codable, CRUDItem, AuthProtocol {
    
    var name: String { get set }
    var email: String { get set }
    var imageURL: String? { get set }
    
    static func getUserHospede() async throws -> Self
    mutating func deleteUser() async throws
}

extension UserProtocol {
    
    init() async throws {
        self = try await Self.getUserHospede()
    }
    
    init(email: String, password: String, isNewUser: Bool = false) async throws {
        if !isNewUser {
            let signInUser = try await Self.signIn(email: email, password: password)
            self = Hospede(user: signInUser) as! Self // TODO: Atualmente estamos instânciando diretamente como Hospede, mas futuramente o user poderá ser um Hostel ou Admin
        } else {
            let newUser = try await Self.createAccount(email: email, password: password)
            self = Hospede(user: newUser) as! Self // TODO: Atualmente estamos instânciando diretamente como Hospede, mas futuramente o user poderá ser um Hostel ou Admin
        }
    }
    
}

extension UserProtocol {
    
    static func getUserHospede() async throws -> Self {
        let user = try self.getAuthenticatedUser()
        return try await self.getItem(for: user.uid)
    }
    
    mutating func deleteUser() async throws {
        try await self.deleteItem()
        try await self.deleteAccount()
    }
    
}
