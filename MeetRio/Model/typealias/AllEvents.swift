//
//  AllEvents.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

typealias AllEvents = [EventDetails]

extension AllEvents {
    
    init() {
        self = []
    }
    
    func getAllEvents(crudGroup: CRUDGroup) async throws -> [EventDetails] {
        let collectionName = String(describing: EventDetails.self)
        return try await crudGroup.getAll(from: collectionName)
    }
}
