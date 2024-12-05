////
////  HostelEvent.swift
////  MeetRio
////
////  Created by Felipe on 22/11/24.
////
//
//import Foundation
//
//// MARK: Transformar "Event" em um protocolo, que o EventDetails e o HostelEvent deverão conformar
//@Observable
//class HostelEventLIXO: EventDetails {
//    var hostelID: String?
//    
//    // Esse init ta uma merda
//    required init(id: String?, tags: [String], tips: [String], safetyRate: Float?, eventCategory: String, dayWeek: String?, otherPictureURLs: [String]?, photoURL: String?, description: String, name: String, address: AddressDetails, dateDetails: DateDetails?, buyURL: String?, hostelID: String) {
//        super.init(id: id, tags: tags, tips: tips, safetyRate: safetyRate, eventCategory: eventCategory, dayWeek: dayWeek, otherPictureURLs: otherPictureURLs, photoURL: photoURL, description: description, name: name, address: address, dateDetails: dateDetails, buyURL: buyURL)
//        self.hostelID = hostelID
//    }
//    
//    // MARK: - Decodable initializer
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        // Decode the `hostelID` property
//        hostelID = try container.decodeIfPresent(String.self, forKey: .hostelID)
//        
//        // Decode properties inherited from `EventDetails`
//        try super.init(from: decoder)
//    }
//    
//    // MARK: - CodingKeys
//    private enum CodingKeys: String, CodingKey {
//        case hostelID
//    }
//}
