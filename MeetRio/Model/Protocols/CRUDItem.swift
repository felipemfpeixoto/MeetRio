//
//  CRUDItem.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseFirestore

let db = Firestore.firestore()

protocol CRUDItem: FirebaseCRUDItem {}

protocol FirebaseCRUDItem: Codable {
    
    var id: String { get set }
    
    static var collectionReference: CollectionReference { get }
    
    func create() async throws
    static func getItem(for id: String) async throws -> Self
    func updateItem() async throws
    func deleteItem() async throws
}

extension FirebaseCRUDItem {
    
    init(id: String) async throws {
        self = try await Self.collectionReference.document(id).getDocument(as: Self.self)
    }
    
    static var collectionReference: CollectionReference {
        // TODO: (0) Substituir isso quando a coluna dos eventos for concertada
        let collectionName = String(describing: Self.self)
        
//        let collectionName = String(describing: Element.self)
        let collection = db.collection(collectionName)
        return collection
    }
    
    func create() async throws {
        try Self.collectionReference.document(self.id).setData(from: self)
        print("Criou")
    }
    
    static func getItem(for id: String) async throws -> Self {
        return try await Self.collectionReference.document(id).getDocument(as: Self.self)
    }
    
    func updateItem() async throws {
        try Self.collectionReference.document(self.id).setData(from: self) // TODO: Precisamos pensar em como vamos fazer a lógica de dar o update (Quando fazer o update)
    }
    
    func deleteItem() async throws {
        try await Self.collectionReference.document(self.id).delete()
    }
    
}




