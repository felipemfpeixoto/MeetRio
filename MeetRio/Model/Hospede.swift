//
//  UserModels.swift
//  MeetRio
//
//  Created by Felipe on 11/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

@Observable
class Hospede: UserProtocol {
    
    // MARK: Propriedades derivadas dos protocolos
    var id: String
    var name: String
    var email: String
    var imageURL: String?
    var loggedCase: LoginCase
    
    // MARK: Propriedades específicas do Hospede
    var country: CountryDetails
    var hostel: String?
    
    init(id: String, name: String, email: String, imageURL: String? = nil, loggedCase: LoginCase, country: CountryDetails, hostel: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.imageURL = imageURL
        self.loggedCase = loggedCase
        self.country = country
        self.hostel = hostel
    }
    
    init(user: User) {
        self.id = user.uid
        self.name = user.displayName ?? ""
        self.email = user.email!
        self.imageURL = user.photoURL?.absoluteString
        self.loggedCase = user.isAnonymous ? .anonymous : .registered
        
        self.country = CountryDetails(name: "Brazil", flag: "🇧🇷")
    }
}
