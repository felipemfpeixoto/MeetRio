//
//  Hostel.swift
//  MeetRio
//
//  Created by Felipe on 01/11/24.
//

import Foundation
import FirebaseFirestore

// Não estamos usando isso ainda
@Observable
class UserHostel: Codable {
    var id: String?
    
    init() {}
    
    init(id: String) {
        self.id = id
    }
}


// Modelo necessário para ler os hostels do firebase
struct Hostel: Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var contact: ContactDetails
    var addressDetails: AddressDetails
    var events: [String]?
    var services: [String]?
    var imageURL: String?
}

struct ContactDetails: Codable {
    var phone: String?
    var email: String?
}


@Observable
class HostelsManager: Codable {
    var hostels: [Hostel] = []
    
    init() {
        Task {
            do {
                // Obtém os documentos da coleção "Hostels" no Firestore
                let snapshot = try await FirestoreManager.shared.db.collection("Hostels").getDocuments()
                // Mapeia os documentos para o modelo Hostel
                self.hostels = snapshot.documents.compactMap { document in
                    try? document.data(as: Hostel.self) // Assume que Hostel conforma com Decodable e FirestoreDecoder
                }
            } catch {
                print("Erro ao carregar hostels: \(error)")
                self.hostels = [] // Retorna um array vazio em caso de erro
            }
            
            print("hostels: ", self.hostels)
        }
    }
}
