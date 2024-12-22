//
//  Hostel.swift
//  MeetRio
//
//  Created by Felipe on 01/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class Hostel: Codable, UserProtocol {
    
    var id: String
    var email: String
    var name: String
    var description: String?
    var phone: String?
    var addressDetails: AddressDetails?
    var services: [String]?
    var imageURL: String?
    
    static var loggedCase: LoginCase = .none
    
    // MARK: Init utilizado apenas quando é criado um novo usuário
    required init(user: User) {
        self.id = user.uid
        self.name = user.displayName ?? ""
        self.email = user.email ?? ""
        self.imageURL = user.photoURL?.absoluteString
    }
    
    init(id: String = UUID().uuidString, email: String, name: String, description: String? = nil, phone: String? = nil, addressDetails: AddressDetails? = nil, services: [String]? = nil, imageURL: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.description = description
        self.phone = phone
        self.addressDetails = addressDetails
        self.services = services
        self.imageURL = imageURL
    }
}
