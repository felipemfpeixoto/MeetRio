//
//  UserProtocol.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol UserProtocol: Codable {
    
    var authProtocol: AuthProtocol { get }
    var crudItem: CRUDItem { get }
    
    var id: String { get set }
    var name: String { get set }
    var imageURL: String? { get set }
    
    func createNewUser() async throws
    func getUser() async throws
    func updateUser() async throws
    func deleteUser() async throws
}
