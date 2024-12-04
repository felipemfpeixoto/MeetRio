//
//  FirestoreItem.swift
//  MeetRio
//
//  Created by Luiz Seibel on 02/12/24.
//

import Firebase
import FirebaseCore
import FirebaseFirestore

// MARK: Mudar para o protocolo de BDItem
protocol BDItemTeste: Codable {
    var id: String { get set }
}

class FirebaseItem: CRUDItem {
    let db = Firestore.firestore()
}

// MARK: CRUD
extension FirebaseItem {
    
    func create<T: BDItemTeste>(_ element: T) async throws {
        let collectionNamge = String(describing: T.self)
        let collection = db.collection(collectionNamge)
        
        do {
            try collection.addDocument(from: element)
        } catch {
            throw error
        }
    }
    
    func getItem<T: Codable>(id: String) async throws -> T {
        let collectionName = String(describing: T.self)
        let documentReference = db.collection(collectionName).document(id)
            
        do {
            let documentSnapshot = try await documentReference.getDocument()
            
            let data = try documentSnapshot.data(as: T.self)
            return data
        } catch {
            throw error
        }
    }
    
    func updateItem<T: BDItemTeste>(_ element: T) async throws {
        let collectionName = String(describing: T.self)
        let documentReference = db.collection(collectionName).document(element.id)
        
        do {
            try documentReference.setData(from: element)
        } catch {
            throw error
        }
    }
    
    
    func deleteItem<T: BDItemTeste>(_ element: T) async throws {
        let collectionName = String(describing: T.self)
        let documentReference = db.collection(collectionName).document(element.id)
        
        do {
            try await documentReference.delete()
        } catch {
            throw error
        }
    }
    
    
}
