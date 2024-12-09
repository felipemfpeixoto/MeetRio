//
//  Hostel.swift
//  MeetRio
//
//  Created by Felipe on 01/11/24.
//

import Foundation
import FirebaseFirestore

// Modelo necessário para ler os hostels do firebase
//struct Hostel: Codable {
//    @DocumentID var id: String?
//    var name: String
//    var description: String?
//    var contact: ContactDetails
//    var addressDetails: AddressDetails
//    var services: [String]?
//    var imageURL: String?
//    var events: [HostelEvent]
//    
//    init(name: String, description: String? = nil, contact: ContactDetails, addressDetails: AddressDetails, services: [String]? = nil, imageURL: String? = nil, events: [HostelEvent] = []) {
//        self.name = name
//        self.description = description
//        self.contact = contact
//        self.addressDetails = addressDetails
//        self.services = services
//        self.imageURL = imageURL
//        self.events = events
//    }
//    
//    init(hostelCE: HostelCodableExtensions) {
//        self.id = hostelCE.id
//        self.name = hostelCE.name
//        if let description = hostelCE.description {
//            self.description = description
//        }
//        self.contact = hostelCE.contact
//        self.addressDetails = hostelCE.addressDetails
//        self.services = hostelCE.services
//        self.imageURL = hostelCE.imageURL
//        self.events = hostelCE.events
//    }
//    
//    func uploadToFirestore() async {
//        do {
//            try FirestoreManager.shared.db.collection("Hostels").document("bvKiWCn1HsejIPr3jCy9").setData(from: self)
//        } catch {
//            print("Erro ao fazer o upload do Hostel: \(error.localizedDescription)")
//        }
//    }
//    
//    mutating func getAllEvents() async {
//        do {
//            let data = try await FirestoreManager.shared.db.collection("HostelEvents").getDocuments()
//            for event in data.documents {
//                do {
//                    let hostelEvent = try event.data(as: HostelEvent.self)
//                    self.events.append(hostelEvent)
//                } catch {
//                    print("Erro ao ")
//                }
//            }
//        } catch {
//            print("Erro ao fazer o get dos HostelEvents: \(error.localizedDescription)")
//        }
//    }
//}
//
//struct ContactDetails: Codable {
//    var phone: String?
//    var email: String?
//}
//
//
//struct HostelCodableExtensions: Codable {
//    var id: String?
//    var name: String
//    var description: String?
//    var contact: ContactDetails
//    var addressDetails: AddressDetails
//    var services: [String]?
//    var imageURL: String?
//    var events: [HostelEvent]
//    
//    init(hostel: Hostel) {
//        self.name = hostel.name
//        self.description = hostel.description
//        self.contact = hostel.contact
//        self.addressDetails = hostel.addressDetails
//        self.services = hostel.services
//        self.imageURL = hostel.imageURL
//        self.events = hostel.events
//    }
//    
//}
