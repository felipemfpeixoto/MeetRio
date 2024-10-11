//
//  CalendarEvent.swift
//  MeetRio
//
//  Created by Felipe on 27/09/24.
//

import Foundation
import Intents
import Contacts
import MapKit

class CalendarEvent {
    let name: String
    let startDate: Date
    let endDate: Date
    let locationName: String
    let latitude: Double
    let longitude: Double
    let street: String
    let city: String
    let state: String
    let postalCode: String
    let country: String
    let isoCountryCode: String
    
    private var reservation: INReservation?
    private var event: INTicketedEvent?
    
    static var eventCount: [String: Int] = [:] {
        didSet {
            saveEventCount()
        }
    }
    
    init(name: String, startDate: Date, endDate: Date, locationName: String, latitude: Double, longitude: Double, street: String, city: String, state: String, postalCode: String, country: String, isoCountryCode: String) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.isoCountryCode = isoCountryCode
        CalendarEvent.loadEventCount()
    }
    
    func reciveAndDonateInteraction() {
        reciveInteraction()
        donateInteraction()
    }
    
    // Função que recebe os dados do evento e faz a doação da interação
    func reciveInteraction() {
        reservation = nil
        event = nil
        
        let eventName = CalendarEvent.getUniqueEventName(for: self.name)
        
        let calendar = Calendar.current
        let myEventStart = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.startDate)
        let myEventEnd = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.endDate)
        
        let duration = INDateComponentsRange(start: myEventStart, end: myEventEnd)
        
        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = self.street
        postalAddress.city = self.city
        postalAddress.state = self.state
        postalAddress.postalCode = self.postalCode
        postalAddress.country = self.country
        postalAddress.isoCountryCode = self.isoCountryCode
        
        let location = MKPlacemark(coordinate: coordinate, postalAddress: postalAddress)
        
        event = INTicketedEvent(
            category: .unknown,
            name: eventName,
            eventDuration: duration,
            location: location
        )
        
        let reservationReference = INSpeakableString(
            vocabularyIdentifier: UUID().uuidString,
            spokenPhrase: self.name,
            pronunciationHint: nil
        )
        
        reservation = INTicketedEventReservation(
            itemReference: reservationReference,
            reservationNumber: "",
            bookingTime: Date(),
            reservationStatus: .confirmed,
            reservationHolderName: "",
            actions: nil,
            reservedSeat: nil,
            event: event!
        )
    }
    
    // Função para doar a interação para o sistema
    private func donateInteraction() {
        guard let reservation = reservation else { return }
        
        let intent = INGetReservationDetailsIntent(
            reservationContainerReference: reservation.itemReference,
            reservationItemReferences: [reservation.itemReference]
        )
        
        let intentResponse = INGetReservationDetailsIntentResponse(code: .success, userActivity: nil)
        intentResponse.reservations = [reservation]
        
        let interaction = INInteraction(intent: intent, response: intentResponse)
        interaction.direction = .outgoing
        
        interaction.donate { error in
            if let error = error {
                print("Erro ao doar a interação: \(error.localizedDescription)")
            } else {
                print("Interação doada com sucesso.")
            }
        }
    }
    
    // Função que retorna um nome de evento único com base no número de vezes que ele foi registrado
    private static func getUniqueEventName(for eventName: String) -> String {
        if let count = eventCount[eventName] {
            let newCount = count + 1
            eventCount[eventName] = newCount
            return "\(eventName) (\(newCount))"
        } else {
            eventCount[eventName] = 0
            return eventName
        }
    }
    
    // Função para salvar o dicionário eventCount no UserDefaults
    private static func saveEventCount() {
        UserDefaults.standard.set(eventCount, forKey: "eventCount")
    }
    
    // Função para carregar o dicionário eventCount do UserDefaults
    private static func loadEventCount() {
        if let savedEventCount = UserDefaults.standard.dictionary(forKey: "eventCount") as? [String: Int] {
            eventCount = savedEventCount
        }
    }
}
