//
//  FirestoreItem.swift
//  MeetRio
//
//  Created by Luiz Seibel on 02/12/24.
//

import Firebase
import FirebaseCore
import FirebaseFirestore


class FirestoreItem: CRUDItem{
    let db = Firestore.firestore()
    
    
    
}

// MARK: CRUD
extension FirestoreItem{
    func create() async throws {
        <#code#>
    }
    
    func getItem(id: String, collection: String) async throws -> Self {
        let documentReference = db.collection(collection).document(id)
            
        do {
            let documentSnapshot = try await documentReference.getDocument()
            
            guard let data = documentSnapshot.data() else {
                throw NSError(domain: "FirestoreItemError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Documento com ID '\(id)' não encontrado."])
            }
            
            print("Documento com ID '\(id)' recuperado com sucesso: \(data)")
            return data
        } catch {
            print("Erro ao recuperar documento com ID '\(id)': \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateItem() async throws {
        <#code#>
    }
    
    
    func deleteItem(id: String, collection: String) async throws {
        let documentReference = db.collection(collection).document(id)
        do {
            try await documentReference.delete()
            print("Documento com ID '\(id)' foi deletado com sucesso.")
        } catch {
            print("Erro ao deletar documento com ID '\(id)': \(error.localizedDescription)")
            throw error
        }
    }
    
    
}


