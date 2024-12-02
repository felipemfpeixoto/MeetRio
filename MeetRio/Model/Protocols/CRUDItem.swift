//
//  CRUDItem.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol CRUDItem{
    func create() async throws
    func getItem(id: String, collection: String) async throws -> Self
    func updateItem() async throws
    func deleteItem(id: String, collection: String) async throws
}
