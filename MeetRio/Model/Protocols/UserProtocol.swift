//
//  UserProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol UserProtocol: Codable, CRUDItem, AuthProtocol {
    
    var name: String { get set }
    var email: String { get set }
    var imageURL: String? { get set }
    var loggedCase: LoginCase
    
    func createNewUser() async throws
    func getUser() async throws
    func updateUser() async throws
    func deleteUser() async throws
    static func getAuthenticatedUser() throws -> Bool
}

extension UserProtocol {
    
    
}
