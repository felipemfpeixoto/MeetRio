//
//  CRUDGroup.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol CRUDGroup{
    func getAll<T: Decodable>(from collection: String) async throws -> [T]
}


// AllEvents ou AllHostels
