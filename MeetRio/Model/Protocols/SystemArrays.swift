//
//  Arrays.swift
//  MeetRio
//
//  Created by Luiz Seibel on 03/12/24.
//

import Foundation

protocol SystemArrays {
    mutating func addElement(_ bdItem: DBItem) throws
    mutating func removeElement(_ bdItem: DBItem) throws
    
    func getLabeledElements(with label: String) throws -> SistemArrays
    func getAllElements() -> SistemArrays
    
}
