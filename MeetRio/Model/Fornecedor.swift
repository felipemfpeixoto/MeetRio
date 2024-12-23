//
//  Fornecedor.swift
//  MeetRio
//
//  Created by Luiz Seibel on 02/12/24.
//

import Foundation

@Observable
class Fornecedor {
    
    static let shared = Fornecedor()
    
    // private(set) var userVariable: UserProtocol? // MARK: Ver qual a melhor forma de atualizar pequenos atributos, como nome, CountryDetails, etc
    
    var userVariable: UserProtocol?
    
    private init() {}
    
    // Monostate
//    private(set) static var allHostels = AllHostels()
    private(set) static var allEvents = AllEvents()
}

// MARK: Extension de autenticação
extension Fornecedor{
    
    func loadAuthUser() async throws {
        userVariable = try await Hospede()
    }
    
    func deleteAuthUser() async throws { // TODO: Não sei se isso ta sendo feito da melhor forma, pois ao chamar o deleteUser, o mesmo deveria "se setar" como nil, certo?
        try await userVariable?.deleteUser()
        userVariable = nil
    }
    
    func anonymousLogin() async throws {
        userVariable = try await Hospede(isAnonymous: true)
    }
    
    func userSignOut() async throws {
        try await Hospede.signOut()
        userVariable = nil
    }
    
    func login(email: String, password: String) async throws {
        userVariable = try await Hospede(email: email, password: password)
    }
    
    func createUser(email: String, password: String) async throws {
        userVariable = try await Hospede(email: email, password: password, isNewUser: true)
    }
    
}
