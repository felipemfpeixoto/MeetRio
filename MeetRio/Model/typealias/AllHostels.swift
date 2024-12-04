//
//  AllHostels.swift
//  MeetRio
//
//  Created by Felipe on 03/12/24.
//

import Foundation

typealias AllHostels = [Hostel]

extension AllHostels {
    
    init() {
        self = []
    }
    
}


// AllEvents ou AllHostels
extension Array: CRUDGroup where Element: CRUDItem {
    
    func getAll() async throws -> [Element] {
        let collectionName = String(describing: Element.self)
        
        return []
    }
    
}
