//
//  MockData.swift
//  MeetRio
//
//  Created by Luiz Seibel on 30/09/24.
//

import UIKit
import Foundation

// Dados fictícios para testes
struct MockData {
    static let eventDetails: EventDetails = {
        let testLocation = LocationDetails(
            latitude: -22.9068,
            longitude: -43.1729,
            mapURL: "https://maps.apple.com/?q=-22.9068,-43.1729"
        )
        
        let testAddress = AddressDetails(
            street: "Avenida dos Artistas",
            number: "123",
            neighborhood: "Centro",
            location: testLocation,
            details: "Perto do Museu",
            referencePoint: "Ao lado do parque"
        )
        
        let testDateDetails = DateDetails(
            startDate: stringToDate("2024-10-14") ?? Date(),
            startHour: 18,
            endHour: 22
        )
        
        let photoData = UIImage(named: "AlbaBotafogo")?.pngData()
        
        let photoData1 = UIImage(named: "AlbaBotafogo_Pequeno")?.pngData()
        let photoData2 = UIImage(named: "MundoLingo_Botafogo_Pequeno")?.pngData()
        
        let testEvent = EventDetails(
            id: "test_event_123",
            name: "Festival de Música",
            address: testAddress,
            dateDetails: testDateDetails,
            description: "Um evento incrível de música ao vivo com várias atrações!",
            photo: photoData,
            buyURL: "https://comprar.ingresso.com/festival",
            otherPictures: [photoData1!, photoData2!],
            tags: ["Música", "Festival", "Ao Vivo"],
            tips: "Chegue cedo para garantir um bom lugar.",
            safetyRate: 4.5,
            eventCategory: "Festival"
        )
        
        return testEvent
    }()
}

func stringToDate(_ dateString: String, format: String = "yyyy-MM-dd") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormatter.date(from: dateString)
}
