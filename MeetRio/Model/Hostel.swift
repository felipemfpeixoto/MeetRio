//
//  Hostel.swift
//  MeetRio
//
//  Created by Felipe on 01/11/24.
//

import Foundation
import FirebaseFirestore

@Observable
class UserHostel: Codable {
    var id: String?
    var name: String?
    var description: String?
    var services: [String]?
    var email: String?
    var location: LocationDetails?
    
    init() {}
    
    init(id: String, name: String, description: String, email: String, services: [String], location: LocationDetails) {
        self.id = id
        self.name = name
        self.description = description
        self.services = services
        self.email = email
        self.location = location
    }
}


// Modelo necessário para ler os hostels do firebase
struct Hostel: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var password: String
    var location: LocationDetails
}
