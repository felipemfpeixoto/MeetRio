//
//  ArraysExtension.swift
//  MeetRio
//
//  Created by Luiz Seibel on 04/12/24.
//

import Foundation
import FirebaseFirestore

extension Array: CRUDGroup where Element: CRUDItem {
    
    static var collectionReference: CollectionReference {
        let collectionName = String(describing: Element.self)
        let collection = db.collection(collectionName)
        return collection
    }
    
    // MARK: Public Methods
    func getAllElements() async throws -> Self{
        var myReturn = getAll_Cache()
        if myReturn.isEmpty {
            try myReturn = await getAll_DB()
        }
        return myReturn
    }
    
//    func getLabeled(label: String) -> Self {
//        return getLabeled_Cache(label: label)
//    }
    

    // MARK: DB Storage Methods
    private func getAll_DB() async throws -> [Element] {
        let querySnapshot = try await Self.collectionReference.getDocuments()
        var documents: [Element] = []
        
        for document in querySnapshot.documents {
            if let elementDoc = try? document.data(as: Element.self) {
                documents.append(elementDoc)
            }
        }
        
        return documents
    }
    
    // MARK: Cached Storage Methods
    private func getAll_Cache() -> Self{
        return self
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
