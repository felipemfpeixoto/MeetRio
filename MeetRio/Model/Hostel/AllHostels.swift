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
            self = try await AllHostels.getAllEvents(crudGroup: crudGroup)
        } catch {
            throw error
        }
    }
    
    private static func getAllEvents(crudGroup: CRUDGroup) async throws -> [Hostel] {
        do {
            let collectionName = String(describing: Hostel.self)
            let allHostels: [Hostel] = try await crudGroup.getAll(from: collectionName)
            return allHostels
        } catch {
            throw error
        }
    }
    
}
