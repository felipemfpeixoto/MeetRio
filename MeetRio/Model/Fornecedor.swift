//
//  Fornecedor.swift
//  MeetRio
//
//  Created by Luiz Seibel on 02/12/24.
//

import Foundation

class Fornecedor{
    
    // Services variables
    let authService: AuthProtocol       // = FirebaseAuth()
    let itemService: CRUDItem           // = FirestoreItem()
    let groupService: CRUDGroup         // = FirestoreGroup()
    
    // ...
    var userVariable: UserProtocol      // = ...
    
    private init(){}
    
    // Monostate
    private(set) static var allHostels = AllHostels()
    private(set) static var allEvents = AllEvents()
}

// MARK: Arrays methods
extension Fornecedor{
    // metodos genéricos para acessar as arrays
    
    func getAllEvents<T: CRUDItem>() -> [T] {
        allHostels.getAll(authService)
    }
    
    func refresh<T: CRUDGroup>() -> T {
        
    }
    
}
