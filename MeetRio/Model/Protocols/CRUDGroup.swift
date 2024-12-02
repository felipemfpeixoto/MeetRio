//
//  CRUDGroup.swift
//  MeetRio
//
//  Created by Felipe on 02/12/24.
//

import Foundation

protocol CRUDGroup{
    func getAll() -> [CRUDItem]
    func getLabeled(label: String) -> [CRUDItem]
}


// AllEvents ou AllHostels
