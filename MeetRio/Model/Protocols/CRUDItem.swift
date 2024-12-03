//
//  CRUDItem.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol CRUDItem{
    func create<T: BDItemTeste>(_ element: T) async throws
    func getItem<T: Codable>(id: String) async throws -> T
    func updateItem<T: BDItemTeste>(_ element: T) async throws
    func deleteItem<T: BDItemTeste>(_ element: T) async throws
}
