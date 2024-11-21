////
////  MockData.swift
////  MeetRio
////
////  Created by Luiz Seibel on 30/09/24.
////

import UIKit
import Foundation


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
            cep: "",
            details: "Perto do Museu",
            referencePoint: "Ao lado do parque"
        )
        
        
        let testDateDetails = DateDetails(
            startDate: "2024-12-14", // Now using String for the date
            endDate: "2024-12-14",
            startHour: "18:00", // Now using String for the hour
            endHour: "22:00"
        )
        
        // Replace UIImage to URLs for photos
        let photoURL = "https://example.com/AlbaBotafogo.png"
        let otherPictureURL1 = "https://example.com/AlbaBotafogo_Pequeno.png"
        let otherPictureURL2 = "https://example.com/MundoLingo_Botafogo_Pequeno.png"
        
        let testEvent = EventDetails(
            id: "test_event_123",
            tags: ["Festival de Música"], // Mantido como array de strings
            tips: ["Festa", "Dança"], // Alterado para uma string simples
            safetyRate: 4.5, // Mantido como está
            eventCategory: "Bem Brazil",
            dayWeek: "Sunday", // Usando uma string simples
            otherPictureURLs: [otherPictureURL1, otherPictureURL2], // Array de URLs como esperado
            photoURL: photoURL, // Mantido como está
            description: "Música, Festival, Ao Vivo", // Alterado para uma string simples
            name: "Ar livre, Para todos, Drinks gratuitos, Cool music, maneiro", // Alterado para uma string simples
            address: AddressDetails(street: "Rua da Boa Vista", number: "33", neighborhood: "Barra", location: LocationDetails(latitude: 54.22, longitude: 54.22)), // Exemplo de preenchimento do parâmetro 'from'
            dateDetails: DateDetails(startDate: "13 de outubro", endDate: "13 de outubro", startHour: "20:00", endHour: "23:00"),
            buyURL: "https://comprar.ingresso.com/festival"
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
