//
//  CRUDItem.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol CRUDItem: Codable {
    func create() async throws
    func getItem() async throws -> Self
    func updateItem() async throws
    func deleteItem() async throws
}
