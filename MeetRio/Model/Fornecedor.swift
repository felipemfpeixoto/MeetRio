//
//  Fornecedor.swift
//  MeetRio
//
//  Created by Luiz Seibel on 02/12/24.
//

import Foundation

@Observable
class Fornecedor {
    
    let shared: Fornecedor = Fornecedor()
    
    private(set) var userVariable: UserProtocol?
    
    private init() {}
    
    // Monostate
//    private(set) static var allHostels = AllHostels()
    private(set) static var allEvents = AllEvents()
}

// MARK: Arrays methods
extension Fornecedor{
    
    func loadAuthUser() async throws {
        userVariable = try await Hospede()
    }
    
}
