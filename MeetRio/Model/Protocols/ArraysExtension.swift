//
//  ArraysExtension.swift
//  MeetRio
//
//  Created by Luiz Seibel on 04/12/24.
//

import Foundation
import FirebaseFirestore

extension Array: CRUDGroup where Element: CRUDItem {
    
    // TODO: Não ta funcionando com a cache ainda
    mutating func getAllElements() async throws {
        var myReturn = getAll_Cache()
        if myReturn.isEmpty {
            try myReturn = await getAll_DB()
        }
        print("MyReturn \(String(describing: Element.self))", myReturn)
        self = myReturn
    }
    
//    func getLabeled(label: String) -> Self {
//        return getLabeled_Cache(label: label)
//    }
    

    // MARK: DB Storage Methods
    private func getAll_DB() async throws -> [Element] {
        let querySnapshot = try await Element.collectionReference.getDocuments()
        var documents: [Element] = []
        for document in querySnapshot.documents {
            do {
                let elementDoc = try document.data(as: Element.self) // TODO: Erro está acontecendo nessa linha
                documents.append(elementDoc)
            } catch {
                print("🤬 Erro ao decodar evento \(document.documentID): \(error.localizedDescription)")
                continue
            }
        }
        return documents
    }
    
    // MARK: Cached Storage Methods
    private func getAll_Cache() -> Self {
        return []
    }
    
    // TODO: Melhorar depois de colocar o event
//    private func getLabeled_Cache(label: String) -> Self{
//        return self.filter { element in
//            element. == label
//        }
//    }
    
    // MARK: Local Storage Methods
    // ...
}
