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

// TODO: (0) Criar um CodingKeys pra essa porra
@Observable
class Hospede: UserProtocol {
    
    // MARK: Propriedades derivadas dos protocolos
    var id: String
    var name: String
    var email: String
    var imageURL: String?
    static var loggedCase: LoginCase = .none
    
    // MARK: Propriedades específicas do Hospede
    var country: CountryDetails? // MARK: Usar o country details para verificar se o user ja acabou de criar o perfil
    var hostel: String?
    
    init(id: String, name: String, email: String, imageURL: String? = nil, country: CountryDetails, hostel: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.imageURL = imageURL
        self.country = country
        self.hostel = hostel
    }
    
    required init(user: User) {
        self.id = user.uid
        self.name = user.displayName ?? ""
        self.email = user.email ?? ""
        self.imageURL = user.photoURL?.absoluteString
    }
}
