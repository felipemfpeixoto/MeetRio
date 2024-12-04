//
//  ArraysExtension.swift
//  MeetRio
//
//  Created by Luiz Seibel on 04/12/24.
//

import Foundation

extension Array: CRUDGroup where Element: CRUDItem {
    
    // MARK: Public Methods
    func getAll() async throws -> Self{
        var myReturn = getAll_Cache()
        if myReturn.isEmpty{
            do{
                try myReturn = await getAll_DB()
            } catch {
                throw(error)
            }
        }
        return myReturn
    }
    
    func getLabeled(label: String) -> Self{
        return getLabeled_Cache(label: label)
    }
    

    // MARK: DB Storage Methods
    private func getAll_DB() async throws -> [Element] {
        let collectionName = String(describing: Element.self)
        
        return []
    }
    
    // MARK: Cached Storage Methods
    private func getAll_Cache() -> Self{
        return self
    }
    
    // TODO: Melhorar depois de colocar o event
    private func getLabeled_Cache(label: String) -> Self{
        return self.filter { element in
            element.label == label
        }
    }
    
    // MARK: Local Storage Methods
    // ...
}
