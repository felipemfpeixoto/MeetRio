////
////  MockData.swift
////  MeetRio
////
////  Created by Luiz Seibel on 30/09/24.
////
//
//import UIKit
//import Foundation
//
//
//struct MockData {
//    static let eventDetails: EventDetailsApi = {
//        let testLocation = LocationDetails(
//            latitude: -22.9068,
//            longitude: -43.1729,
//            mapURL: "https://maps.apple.com/?q=-22.9068,-43.1729"
//        )
//        
//        let testAddress = AddressDetails(
//            street: "Avenida dos Artistas",
//            number: "123",
//            neighborhood: "Centro",
//            location: testLocation,
//            cep: "",
//            details: "Perto do Museu",
//            referencePoint: "Ao lado do parque"
//        )
//        
//        let testDateDetails = DateDetails(
//            startDate: "2024-10-14", // Now using String for the date
//            endDate: "2024-10-14",
//            startHour: "18:00", // Now using String for the hour
//            endHour: "22:00"
//        )
//        
//        // Replace UIImage to URLs for photos
//        let photoURL = "https://example.com/AlbaBotafogo.png"
//        let otherPictureURL1 = "https://example.com/AlbaBotafogo_Pequeno.png"
//        let otherPictureURL2 = "https://example.com/MundoLingo_Botafogo_Pequeno.png"
//        
//        let testEvent = EventDetailsApi(
//            id: "test_event_123",
//            name: "Festival de Música",
//            address: testAddress,
//            dateDetails: testDateDetails,
//            description: "Um evento incrível de música ao vivo com várias atrações!",
//            photoURL: photoURL, // Using URL string instead of Data
//            buyURL: "https://comprar.ingresso.com/festival",
//            otherPictureURLs: [otherPictureURL1, otherPictureURL2], // Using URLs array instead of Data
//            tags: ["Música", "Festival", "Ao Vivo"],
//            tips: ["Ar livre", "Para todos", "Drinks gratuitos", "Cool music", "maneiro"],
//            safetyRate: 4.5,
//            eventCategory: "Festival"
//        )
//        
//        return testEvent
//    }()
//}
//
//
//func stringToDate(_ dateString: String, format: String = "yyyy-MM-dd") -> Date? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = format
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//    return dateFormatter.date(from: dateString)
//}
