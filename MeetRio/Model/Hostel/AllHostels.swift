//
//  AllHostels.swift
//  MeetRio
//
//  Created by Felipe on 03/12/24.
//

import Foundation

typealias AllHostels = [Hostel]

extension AllHostels {
    
    init(crudGroup: CRUDGroup) async throws {
        do {
            self = try await self.getAllEvents(crudGroup: crudGroup)
        } catch {
            throw error
        }
    }
    
    func getAllEvents(crudGroup: CRUDGroup) async throws -> [Hostel] {
        let collectionName = String(describing: Hostel.self)
        return try await crudGroup.getAll(from: collectionName)
    }
    
}
