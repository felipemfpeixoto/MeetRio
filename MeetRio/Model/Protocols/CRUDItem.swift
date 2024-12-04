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
    
    func create() async throws
    mutating func getItem(for id: String) async throws
    func updateItem() async throws
    func deleteItem() async throws
}

extension FirebaseCRUDItem {
    
    init(id: String) async throws {
        do {
            try await getItem(for: id)
        } catch {
            throw error
        }
    }
    
    private func getCollectionReference() -> CollectionReference {
        let collectionName = String(describing: Self.self)
        let collection = db.collection(collectionName)
        return collection
    }
    
    func create() async throws {
        let collection = self.getCollectionReference()
        
        do {
            try collection.addDocument(from: self)
        } catch {
            throw error
        }
    }
    
    mutating func getItem(for id: String) async throws {
        let collection = self.getCollectionReference()
        
        do {
            self = try await collection.document(id).getDocument() as! Self
        } catch {
            throw error
        }
    }
    
    func updateItem() async throws {
        let collection = self.getCollectionReference()
        
        do {
            try collection.document(self.id).setData(from: self) // TODO: Precisamos pensar em como vamos fazer a lógica de dar o update (Quando fazer o update)
        } catch {
            throw error
        }
    }
    
    func deleteItem() async throws {
        let collection = self.getCollectionReference()
        
        do {
            try await collection.document(self.id).delete()
        } catch {
            throw error
        }
    }
    
}




