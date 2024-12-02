//
//  FirestoreGroup.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation
import FirebaseFirestore

class FirebaseGroup: CRUDGroup {
    
    let db = Firestore.firestore()
    
    func getAll<T: Decodable>(from collection: String) async throws -> [T] {
        do {
            let querySnapshot = try await db.collection(collection).getDocuments()
            var results: [T] = []

            for document in querySnapshot.documents {
                do {
                    let item = try document.data(as: T.self)
                    results.append(item)
                } catch {
                    print("Erro ao decodificar o documento: \(error)")
                    // Você pode optar por lançar o erro ou continuar
                }
            }

            return results
        } catch {
            throw error // Propaga o erro para quem chamar a função
        }
    }
}
