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
    
    static var collectionReference: CollectionReference {
        let collectionName = String(describing: Self.self)
        let collection = db.collection(collectionName)
        return collection
    }
    
    static private func getCollectionReference() -> CollectionReference {
        let collectionName = String(describing: Self.self)
        let collection = db.collection(collectionName)
        return collection
    }
    
    func create() async throws {
        try Self.collectionReference.addDocument(from: self)
    }
    
    static func getItem(for id: String) async throws -> Self {
        return try await Self.collectionReference.document(id).getDocument() as! Self
    }
    
    func updateItem() async throws {
        try Self.collectionReference.document(self.id).setData(from: self) // TODO: Precisamos pensar em como vamos fazer a lógica de dar o update (Quando fazer o update)
    }
    
    func deleteItem() async throws {
        try await Self.collectionReference.document(self.id).delete()
    }
    
}




